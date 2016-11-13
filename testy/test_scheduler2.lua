--test_scheduler.lua
package.path = package.path..";../?.lua"

Scheduler = require("schedlua.scheduler")()
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

-- local function spawn(func, ...)
-- 	return coop(100, func, ...);
-- end

local function task1()
	print("first task, line 1")
	print("first task, line 2")
end

local function task2()
	print("second task, only line")
end

local function task3()
    print("task three")
end

local function task4()
    print("4 baby!")
end

local function main()
    print("in Main")
    local t3 = coop(3, Scheduler, task3)
	local t1 = coop(5, Scheduler, task1)
	local t2 = coop(1, Scheduler, task2)
    local t4 = coop(2, Scheduler, task4)
    -- print("tasks pending", Scheduler.tasksPending(Scheduler))

	while (true) do
		--print("STATUS: ", t1:getStatus(), t2:getStatus())
		if t1:getStatus() == "dead" 
            and t2:getStatus() == "dead" 
            and t3:getStatus() == "dead"  
            and t4:getStatus() == "dead"
            then
			break;
		end
		Scheduler:step()
	end
end

main()


