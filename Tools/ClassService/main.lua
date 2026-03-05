local ClassHierarchy = {
    Instance = {
        -- OBJECTS
        Game = true,
        Environment = true,
        Lighting = true,
        ScriptService = true,
        Hidden = true,
        ServerHidden = true,
        PlayerDefaults = true,
        Players = true,
        Backpack = true,
        DynamicInstance = {
            -- OBJECTS
            Camera = true,
            Player = true,

            -- WORLD
            Part = {
                MeshPart = true,
                Climbable = {
                    Truss = true
                }
            },
            Text3D = true,
            NPC = true,
            Model = true,
            Tool = true,

            -- EFFECTS AND UTILITIES
            Decal = true,
            Particles = true,
            PointLight = true,
            SpotLight = true,
            SunLight = true,
            Sound = true,
        },

        -- WORLD
        Folder = true,

        -- EFFECTS AND UTILITIES
        ImageSky = true,
        GradientSky = true,
        ProceduralSky = true,

        -- PHYSICS
        BodyPosition = true,

        -- SCRIPTING
        BaseScript = {
            ScriptInstance = true,
            LocalScript = true,
            ModuleScript = true
        },
        NetworkEvent = true,

        -- VALUES
        ValueBase = {
            BoolValue = true,
            ColorValue = true,
            InstanceValue = true,
            IntValue = true,
            NumberValue = true,
            StringValue = true,
            Vector3Value = true,
        },

        -- UI
        PlayerGUI = true,
        GUI = true,
        UIField = {
            UIImage = true,
            UIView = {
                UITextInput = true,
                UILabel = {
                    UIButton = true
                }
            },

            UIHVLayout = {
                UIHorizontalLayout = true,
                UIVerticalLayout = true
            }
        }
    }
}

local ClassAncestry = (function()
    local function getClassParents(table, parent, t)
        t = t or {}

        for class, value in pairs(table) do
            if type(value) =="table" then
                t[class] = parent
                getClassParents(value, class, t)
            else
                t[class] = parent
            end
        end

        return t
    end

    local objs = getClassParents(ClassHierarchy)

    local function setClassParents(class_name)
        if class_name == "Instance" then return "Instance" end
        local t = {}

        for class, parent in pairs(objs) do
            if class == class_name then
                if parent == "Instance" then 
                    t[class] = "Instance"
                else
                    t[class] = setClassParents(parent) 
                end
            end
        end

        return t
    end

    local final = {}
    for class, parent in pairs(objs) do final[class] = setClassParents(parent) end
    
    return final
end)()

local Classes = (function()
    local function getClasses(tbl, parent, t)
        t = t or {}

        for class, value in pairs(tbl) do
            if type(value) =="table" then
                table.insert(t, class)
                getClasses(value, class, t)
            else
                table.insert(t, class)
            end
        end

        return t
    end

    return getClasses(ClassHierarchy)
end)()

local function getClassInheritance(tbl, parent_class_name, class_name)
    for class, parent in pairs(tbl) do
        if class_name and class ~= class_name then goto here end
        if class == parent_class_name then return true end

        if type(parent) == "table" then
            return getClassInheritance(parent, parent_class_name)
        else
            if parent == parent_class_name then return true end
        end

        ::here::
    end

    return false
end

local function IsClass(class_name)
    for _, class in ipairs(Classes) do if class == class_name then return true end end
    return false
end

return {
    IsInheritingClass = function(parent_class_name, instance)
        assert(IsClass(parent_class_name), parent_class_name.." is NOT a class!")
        assert(type(instance) =='userdata' , tostring(instance).." is NOT an instance!")
        return getClassInheritance(ClassAncestry, parent_class_name, instance.ClassName) 
    end
}
