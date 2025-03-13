from qutebrowser.api import hook, message


@hook.init()
def init(ctx):
    message.info("Hello, world! from dummy")
