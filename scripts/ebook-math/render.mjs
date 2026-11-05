// 電子書建置用：把 md2adoc 產生的 AsciiDoc 裡的 latexmath 公式換成 SVG 圖片。
// 網站用 KaTeX 在瀏覽器排版公式；asciidoctor-pdf 與 asciidoctor-epub3 都不會排版 latexmath，
// 不處理的話電子書裡只會看到 TeX 原始碼。
//
// 用法：node scripts/ebook-math/render.mjs <book.adoc 所在目錄>
//   - 區塊公式 [latexmath] ++++ … ++++ → image::images/math/<sha1>.svg[…]
//   - 行內公式 latexmath:[…] → image:images/math/<sha1>.svg[…]
//   SVG 寫到 <目錄>/images/math/，與建置時複製過去的書中圖片放在一起（建置時 -a imagesdir= 用相對路徑）。
import { createHash } from 'node:crypto';
import { mkdirSync, readdirSync, readFileSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';
import { mathjax } from 'mathjax-full/js/mathjax.js';
import { TeX } from 'mathjax-full/js/input/tex.js';
import { SVG } from 'mathjax-full/js/output/svg.js';
import { liteAdaptor } from 'mathjax-full/js/adaptors/liteAdaptor.js';
import { RegisterHTMLHandler } from 'mathjax-full/js/handlers/html.js';
import { AllPackages } from 'mathjax-full/js/input/tex/AllPackages.js';

// MathJax 的尺寸單位是 ex；prawn-svg（asciidoctor-pdf）不認得 ex，換成 pt。
// 內文 10.5pt 左右，1ex 約為字級的一半
const EX_TO_PT = 5;

const dir = process.argv[2];
if (!dir) {
  console.error('用法：node scripts/ebook-math/render.mjs <book.adoc 所在目錄>');
  process.exit(1);
}

const adaptor = liteAdaptor();
RegisterHTMLHandler(adaptor);
const doc = mathjax.document('', {
  InputJax: new TeX({ packages: AllPackages }),
  OutputJax: new SVG({ fontCache: 'none' }),
});

const outDir = join(dir, 'images', 'math');
mkdirSync(outDir, { recursive: true });

function render(tex, display) {
  const node = doc.convert(tex, { display });
  const svgNode = adaptor.firstChild(node);
  if (adaptor.innerHTML(svgNode).includes('data-mjx-error')) throw new Error(`公式無法排版：${tex}`);
  let svg = adaptor.outerHTML(svgNode)
    .replace(/(width|height)="([\d.]+)ex"/g, (_, k, v) => `${k}="${(parseFloat(v) * EX_TO_PT).toFixed(2)}pt"`)
    .replace(/ style="[^"]*"/, '')
    .replace(/currentColor/g, '#000');
  const name = createHash('sha1').update(`${display ? 'block' : 'inline'}:${tex}`).digest('hex').slice(0, 12) + '.svg';
  writeFileSync(join(outDir, name), `<?xml version="1.0" encoding="UTF-8"?>\n${svg}\n`);
  return `images/math/${name}`;
}

let blocks = 0;
let inline = 0;
for (const file of readdirSync(dir).filter((f) => f.endsWith('.adoc'))) {
  const path = join(dir, file);
  const src = readFileSync(path, 'utf8');
  const out = src
    .replace(/^\[latexmath\]\n\+\+\+\+\n([\s\S]*?)\n\+\+\+\+$/gm, (_, tex) => {
      blocks++;
      return `image::${render(tex, true)}[數學公式,align=center]`;
    })
    .replace(/latexmath:\[((?:\\\]|[^\]])*)\]/g, (_, tex) => {
      inline++;
      return `image:${render(tex.replace(/\\\]/g, ']'), false)}[數學公式]`;
    });
  if (out !== src) writeFileSync(path, out);
}
console.log(`公式轉成 SVG：區塊 ${blocks} 條、行內 ${inline} 條 → ${outDir}`);
