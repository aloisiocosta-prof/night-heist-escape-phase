const { chromium } = require('playwright');
const fs = require('node:fs');
(async () => {
  fs.mkdirSync('build/visual-web', {recursive:true});
  const browser = await chromium.launch({headless:true,args:['--use-gl=angle','--use-angle=swiftshader','--enable-unsafe-swiftshader']});
  const page = await browser.newPage({viewport:{width:1280,height:720}});
  const messages=[];
  const captures=[];
  let passed=false;
  page.on('console', msg => {
    const text=msg.text(); messages.push(text);
    if(text.includes('QA_STAGE ')) {
      const stage=text.slice(text.indexOf('QA_STAGE ')+9).trim();
      captures.push(page.screenshot({path:`build/visual-web/${stage}.png`}));
    }
    if(text.trim()==='QA_PASS') passed=true;
  });
  page.on('pageerror', error=>messages.push(`PAGEERROR: ${error.message}`));
  await page.goto('http://127.0.0.1:8080/index.html');
  await page.waitForFunction(()=>document.querySelector('canvas')?.width>0);
  for(let i=0;i<90&&!passed;i++) await page.waitForTimeout(1000);
  await Promise.all(captures);
  fs.writeFileSync('build/visual-web/console.txt',messages.join('\n'));
  fs.writeFileSync('build/visual-web/report.json',JSON.stringify({passed,stages:captures.length},null,2));
  await browser.close();
  if(!passed||captures.length<7||messages.some(t=>t.includes('QA_FAIL')||t.includes('SCRIPT ERROR:')||t.includes('PAGEERROR:'))) throw new Error('Web visual QA failed; inspect artifacts');
})();
