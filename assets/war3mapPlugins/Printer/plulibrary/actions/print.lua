function POK(msg)
    echo(colour.hex(colour.green, PMSG_OK .. ':' .. msg))
end

function PFail(msg)
    echo(colour.hex(colour.red, PMSG_FAIL .. ':' .. msg))
end