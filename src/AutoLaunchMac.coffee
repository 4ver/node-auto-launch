applescript = require 'applescript'

tellTo = 'tell application "System Events" to '

module.exports =

    enable: (opts) ->
        new Promise (resolve, reject) ->
            isHidden = if opts.isHiddenOnLaunch then 'true' else 'false'
            properties = "{path:\"#{opts.appPath}\", hidden:#{isHidden}, name:\"#{opts.appName}\"}"
            command = "#{tellTo} make login item at end with properties #{properties}"

            applescript.execString command, (err) ->
                return reject(err) if err?
                resolve()

    disable: (opts) ->
        new Promise (resolve, reject) ->
            command = tellTo + "delete login item \"#{opts.appName}\""

            applescript.execString command, (err) ->
                return reject(err) if err?
                resolve()

    isEnabled: (opts) ->
        new Promise (resolve, reject) ->
            command = tellTo + "get the name of every login item"

            applescript.execString command, (err, loginItems) ->
                return reject(err) if err?

                isPresent = loginItems?.indexOf(opts.appName)
                resolve(isPresent? and isPresent isnt -1)
