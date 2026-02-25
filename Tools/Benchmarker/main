-- Made for Polytoria 1.x
-- by Vran
-- https://polytoria.com/u/Vran

----- Benchmarker v1.0
-- A simple utility script to help you test and compare the performance of your scripts


local ScriptService = game['ScriptService']
local Utils = ScriptService['Utils']

---- Dependencies ----
local Log = require(Utils["Log"])



local function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end



local benchmark = {}

local function test(title, repeats, snippet, pause)
    local timestamps = {}
    Log.warn('---// BENCHMARK '..title..' HAS STARTED //---')

    for pass = 1, repeats do
        timestamps[pass] = {}

        local start = os.clock()

        snippet({
            Split = function(pause)
                table.insert(timestamps[pass], os.clock() - start)
                wait(pause)
                start = os.clock()
            end
        })

        table.insert(timestamps[pass], os.clock() - start)

        print(string.format('--// BMRK "%s" PASS: %d/%d', title, repeats, pass))
        wait(pause)
    end

    Log.warn('---// BENCHMARK '..title..' HAS ENDED //---')
    return timestamps
end

local function parseResults(timestamps)
    local total_times = {}
    for pass, section_table in ipairs(timestamps) do
        for section, time_elapsed in ipairs(section_table) do
            if not total_times[section] then
                total_times[section] = {
                    Sorted = {},
                    Min = 2^100,
                    Max = 0,
                    Average = 0,
                    Median = 0,
                    Accumulated = 0,
                }
            end

            total_times[section] = {
                Min = time_elapsed <= total_times[section].Min and time_elapsed or total_times[section].Min,
                Max = time_elapsed > total_times[section].Max and time_elapsed or total_times[section].Max,
                Accumulated = total_times[section].Accumulated + time_elapsed,
                Sorted = (function() table.insert(total_times[section].Sorted, time_elapsed) return total_times[section].Sorted end)()
            }
        end
    end

    for section, Values in ipairs(total_times) do
        table.sort(total_times[section].Sorted)
        total_times[section].Median = total_times[section].Sorted[round(#timestamps / 2)]
        total_times[section].Average = total_times[section].Accumulated / #timestamps
    end

    return total_times
end

local function Results_toString(result_properties)
    return string.format(
        '     Average:     %.7f\n     Median:      %.7f\n     Fastest:     %.7f\n     Slowest:     %.7f\n     Accumulated: %.7f\n',
        result_properties.Average,
        result_properties.Median,
        result_properties.Min,
        result_properties.Max,
        result_properties.Accumulated
    )
end



--[[
    NOTE: Your code has to have a SAME amount of splits to function properly
    
    Use this for comparisons
    Dont forget to call ".Finish()" at the end of the chain

    benchmark.Start(
        title:      string                              Title of the Benchmark
        repeats:    number                              How many times to run the test
        snippet:    ({                                  The function that is ran. This is where you put your code
                        Split: (pause: number?) -> ()   Splits the timer, like a stopwatch lap. Optional pause will not affect elapsed time
                    }) -> ()
        pause:      number?                             Wait time between tests (does not affect elapsed time)
    ) -> {
        actions.And(                                    Can be Chained
            title: string, 
            snippet: function,                          Same as above 
            pause: number?
        ) -> actions..., 
        actions.Finish()                                Must be always be called. Otherwise, no results 
    }
]]
function benchmark.Start(title, repeats, snippet, pause)
    assert(type(title) == "string", title..' is a NOT a string!')
    assert(type(repeats) == "number", repeats..' is a NOT a number!')
    assert(type(snippet) == "function", 'This is NOT a function!')
    
    local timestamps = test(title, repeats, snippet, pause or 0)

    local _batches = {}
    table.insert(_batches, {
        title = title,
        timestamps = timestamps,
        total_times = parseResults(timestamps),
    })

    local actions = {}
    
    function actions.And(title, snippet, pause)
        assert(type(title) == "string", title..' is a NOT a string!')
        assert(type(snippet) == "function", 'This is NOT a function!')
    
        local timestamps = test(title, repeats, snippet, pause or 0)

        table.insert(_batches, {
            title = title,
            timestamps = timestamps,
            total_times = parseResults(timestamps),
        })

        return actions
    end
    
    function actions.Finish()
        local _combinedSections = {}
        local msg = string.format('---// BENCHMARK RESULTS (%d passes)\n', #timestamps)

        for _, values in ipairs(_batches) do
            for section_number, properties in ipairs(values.total_times) do
                if not _combinedSections[section_number] then _combinedSections[section_number] = {} end
                table.insert(_combinedSections[section_number], properties)
            end
        end

        for section_number, tbl in ipairs(_combinedSections) do
            msg = msg..string.format('---/ SECTION #%d /\n', section_number)
            for batch_number, properties in ipairs(tbl) do
                msg = msg..string.format('\\ %s /\n', _batches[batch_number].title)..Results_toString(properties)..'=~=~=~=~=~=~=~=~=~=~=~=~=~=~=\n'
            end
        end

        Log.yellow(msg)
        return _batches
    end
    
    return actions
end

--[[ 
    For general uses

    benchmark.Test(
        title:      string                              Title of the Benchmark
        repeats:    number                              How many times to run the test
        snippet:    ({                                  The function that is ran. This is where you put your code
                        Split: (pause: number?) -> ()   Splits the timer, like a stopwatch lap. Optional pause will not affect elapsed time
                    }) -> ()
        pause:      number?                             Wait time between tests (does not affect elapsed time)
    )
]]
function benchmark.Test(title, repeats, snippet, pause)
    assert(type(title) == "string", title..' is a NOT a string!')
    assert(type(repeats) == "number", repeats..' is a NOT a number!')
    assert(type(snippet) == "function", 'This is NOT a function!')

    local timestamps = test(title, repeats, snippet, pause or 0)
    local total_times = parseResults(timestamps)

    local msg = string.format('---// BENCHMARK "%s" RESULTS (%d passes)\n', title, #timestamps)
    for section, Values in ipairs(total_times) do
        msg = msg..string.format('-- SECTION #%d--\n', section)..Results_toString(Values)
    end
    
    Log.yellow(msg)
    return total_times
end

return benchmark
