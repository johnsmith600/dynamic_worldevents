UIWrapper = {}

function UIWrapper.OpenMenu(options)
    -- Try ox_lib first
    if GetResourceState('ox_lib') == 'started' then
        local oxOptions = {}
        for _, opt in ipairs(options) do
            if not opt.isMenuHeader then
                table.insert(oxOptions, {
                    label = opt.header,
                    description = opt.txt,
                    onSelect = function()
                        if opt.params.isServer then
                            TriggerServerEvent(opt.params.event, opt.params.args)
                        else
                            TriggerEvent(opt.params.event, opt.params.args)
                        end
                    end
                })
            end
        end
        lib.registerContext({
            id = 'dw_admin_menu',
            title = options[1].header or 'Admin Menu',
            options = oxOptions
        })
        lib.showContext('dw_admin_menu')
        return
    end

    -- Try qb-menu
    if GetResourceState('qb-menu') == 'started' then
        exports['qb-menu']:openMenu(options)
        return
    end

    -- Fallback to bridge
    if true and UIWrapper.OpenMenu then
        UIWrapper.OpenMenu(options)
    end
end
