import { Handler } from './handler.js';

var hw_json_parced = JSON.parse(hw_json);

const hw_handler = new Handler(hw_json_parced, N_TASKS, ID);

hw_handler.showTasks();
hw_handler.showLevelLabs();
hw_handler.showInputRequirements();
hw_handler.showHints();
hw_handler.hideAutocheck();

// ans = hw_handler.get_ans();

function check(id, ans) {
  hw_handler.checker(id, ans[id])
}