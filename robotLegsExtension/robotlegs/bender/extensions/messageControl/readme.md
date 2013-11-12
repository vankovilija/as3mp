# MessageControl extension

## Overview

You can use the MessageControl extension to easily integrate the AS3MessagesController library into your robot legs project.
To use it you simple install it in your robotlegs context by doing:

    context.install(MessageControlExtension);

This will inject a instance of IMessageControl type, you can use this instance to map your testProcessors to it, as well as to process message objects and to register data types.
All mapped MessageProcessor classes to this instance will be also injected into with all the robotlegs dependencies that you have setup, just like a command.