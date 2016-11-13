--test_scheduler.lua
package.path = package.path..";../?.lua"

Scheduler = require("schedlua.scheduler_og")()
Task = require("schedlua.task")
local taskID = 0;

local function getNewTaskID()
	taskID = taskID + 1;
	return taskID;
end

-- local function spawn(scheduler, func, ...)
-- 	local task = Task(func, ...)
-- 	task.TaskID = getNewTaskID();
-- 	Scheduler:scheduleTask(task, {...});
	
-- 	return task;
-- end

local function coop(priority, func, func, ...)
    print("in coop")
	local task = Task(func, ...)
	task.TaskID = getNewTaskID();
	task.Priority = priority;
	Scheduler:scheduleTask(task, {...});

    return task;
end

local function task1()
	print("first task, first line")
	-- Scheduler:yield();
	print("first task, second line")
end

local function task2()
	print("second task, only line")
end

local function task3()
    print("task three")
end

local function main()
    local t3 = coop(2, Scheduler, task3)
	local t1 = coop(100, Scheduler, task1)
	local t2 = coop(0, Scheduler, task2)

	while (true) do
		--print("STATUS: ", t1:getStatus(), t2:getStatus())
		if t1:getStatus() == "dead" and t2:getStatus() == "dead" and t3.getStatus() == "dead" then
			break;
		end
		Scheduler:step()
	end
end

main()


