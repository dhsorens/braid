// The first JavaScript examples. V8 compiles a function to machine code once it has run
// often enough, with the types it has seen: here, small integers. `emit_s.py` runs this file
// under `node --print-opt-code` and keeps the code TurboFan produced.

function js_add3(a, b, c) { return (a + b + c) | 0; }

function js_max(a, b) { return a > b ? a : b; }

let s = 0;
for (let i = 0; i < 200000; i++) {
  s = (s + js_add3(i, i + 1, i + 2) + js_max(i, s & 1023)) | 0;
}
console.log(s);
