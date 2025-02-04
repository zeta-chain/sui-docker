# Build application
#
# Copy in all crates, Cargo.toml and Cargo.lock unmodified,
# and build the application.
FROM rust:1.81-bullseye AS builder
RUN apt-get update && apt-get install -y cmake clang

ARG VERSION=main
RUN git clone --depth=1 --branch ${VERSION} https://github.com/MystenLabs/sui
WORKDIR "$WORKDIR/sui"

ARG PROFILE=release
RUN cargo build --profile ${PROFILE} --bin sui

# Production Image
FROM debian:bullseye-slim AS runtime
RUN apt-get update && apt-get install -y ca-certificates curl
WORKDIR "$WORKDIR/sui"
COPY --from=builder /sui/target/release/sui /usr/local/bin
