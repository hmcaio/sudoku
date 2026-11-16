# Build stage: compile the original Pascal source with Free Pascal.
FROM debian:13.7-slim AS build
RUN apt-get update \
 && apt-get install -y --no-install-recommends fp-compiler=3.2.2+dfsg-46 \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /build
COPY ["pascal/Sudoku 2.2.txt", "sudoku.pas"]
# -Mtp: Turbo Pascal mode (16-bit integer keeps the tempos.bin layout).
RUN fpc -Mtp sudoku.pas

# Runtime stage: the (statically linked) binary plus a filter that turns the
# game's CP437 glyph bytes into UTF-8 (perl and script ship with the base image).
FROM debian:13.7-slim
ENV TERM=xterm-256color
RUN useradd --create-home --shell /usr/sbin/nologin sudoku \
 && mkdir /data && chown sudoku:sudoku /data
COPY --from=build /build/sudoku /usr/local/bin/sudoku
COPY docker/cp437-to-utf8.pl /usr/local/bin/cp437-to-utf8.pl
COPY --chmod=755 docker/entrypoint.sh /usr/local/bin/entrypoint.sh
USER sudoku
# tempos.bin (best times) is written to the working directory.
WORKDIR /data
VOLUME /data
ENTRYPOINT ["entrypoint.sh"]
