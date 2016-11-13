Scheduler = require("schedlua.scheduler")()
Task = require("schedlua.task")
Queue = require("schedlua.queue")

print("Hello")
local s = Scheduler.init(self)
print(s, s.Task)

-- aTable = {}

-- for i = 1, 10 do
--     aTable[i] = i
-- end

-- table.insert(aTable, 1, 5)

-- io.write("First: ", aTable[1], "; Last: ", aTable[10], "\n")
-- for i = 1, #aTable do
--     io.write(aTable[i], "\n")
-- end

-- local function coop(priority, func, ...)
-- 	local task = Task(func, ...)
-- 	task.TaskID = getNewTaskID();
-- 	task.Priority = priority;
-- 	return Kernel.Scheduler:scheduleTask(task, {...});
-- end

-- local function spawn(scheduler, ...)
-- 	return coop(100, func, ...);
-- end