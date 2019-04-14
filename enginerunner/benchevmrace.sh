#!/usr/bin/env bash

# first take dir of wasm files, and inject standalone metering on them

#WASM_FILE_DIR=/wasmfiles

WASM_FILE_DIR=/evmwasmfiles
WASM_METERED_DIR=/evmwasmfilesmetered

echo "building sentinel-rs branch inline-super-standalone..."
cd /root
git clone --single-branch --branch inline-super-standalone https://github.com/ewasm/sentinel-rs.git sentinel-inline-super-standalone
# .cargo/config sets default build target to wasm
rm sentinel-inline-super-standalone/.cargo/config
cd sentinel-inline-super-standalone/wasm-utils/cli
cargo build --bin wasm-gas
# built binary sentinel-rs/wasm-utils/target/debug/wasm-gas

echo "injecting metering into wasm files..."
mkdir -p ${WASM_METERED_DIR}
cd "${WASM_FILE_DIR}"
for filename in *.wasm
do
  dest="${WASM_METERED_DIR}/${filename}"
  /root/sentinel-inline-super-standalone/wasm-utils/target/debug/wasm-gas "${filename}" "$dest"
done


# python3.7 main.py --wasmdir="/evmwasmfilesmetered" --csvfile="/testresults/evmrace_wasm_results.csv" |& tee wasm-run1.log

# "wagon,wabt,v8-liftoff,v8-turbofan,v8-interpreter,wasmtime,wavm,life-polymerase,life,wasmi,asmble"

# only run interpreters
# python3.7 main.py --wasmdir="/evmwasmfilesmetered" --csvfile="/testresults/evmrace_wasm_results.csv" --engines="wagon,wabt,life,wasmi,v8-interpreter" |& tee wasm-run2.log
