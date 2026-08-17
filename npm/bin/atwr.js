#!/usr/bin/env node
import { readFileSync, writeFileSync } from "node:fs";
import { stdin } from "node:process";
import { removeInvisibleCharacters, scanInvisibleCharacters, stripMarkdownPasteResidue } from "../src/index.js";

const HELP = `Usage: atwr <command> [options] [file...]

Commands:
  scan   Detect invisible Unicode characters and print positions
  clean  Remove invisible characters, preserve visible text
  tidy   Strip common Markdown paste artifacts

Options:
  -o, --output <file>  Write result to file instead of stdout
  -r, --recursive      Process files in subdirectories
  -q, --quiet          Suppress informational output
  -h, --help           Show this help message

All processing is local. No network requests are made.`;

function parseArgs(args) {
  const options = { files: [], output: "", quiet: false };
  for (let index = 0; index < args.length; index += 1) {
    const arg = args[index];
    if (arg === "-o" || arg === "--output") options.output = args[++index] ?? "";
    else if (arg === "-q" || arg === "--quiet") options.quiet = true;
    else if (arg === "-h" || arg === "--help") options.help = true;
    else options.files.push(arg);
  }
  return options;
}

async function readInput(files) {
  if (files.length) return files.map((file) => readFileSync(file, "utf8")).join("\n");
  return new Promise((resolve, reject) => {
    let data = "";
    stdin.setEncoding("utf8");
    stdin.on("data", (chunk) => { data += chunk; });
    stdin.on("end", () => resolve(data));
    stdin.on("error", reject);
  });
}

const [command = "", ...args] = process.argv.slice(2);
const options = parseArgs(args);
if (options.help || !command) {
  console.log(HELP);
  process.exit(0);
}

const input = await readInput(options.files);
let output;
if (command === "scan") output = `${JSON.stringify(scanInvisibleCharacters(input), null, 2)}\n`;
else if (command === "clean") output = removeInvisibleCharacters(input);
else if (command === "tidy") output = stripMarkdownPasteResidue(input);
else {
  console.error(`Unknown command: ${command}`);
  process.exit(2);
}

if (options.output) writeFileSync(options.output, output);
else process.stdout.write(output);
