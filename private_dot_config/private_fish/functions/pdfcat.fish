function pdfcat --description 'Preview PDF in terminal using pdfium and timg'
    # TODO: add cleanup
    set -l tmpfile (mktemp)
    pdfium-cli render $argv[1] - > $tmpfile
    timg --pixelation=kitty -W $tmpfile
end
