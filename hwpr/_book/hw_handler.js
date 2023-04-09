import { Handler } from './handler.js';

var hw_json = JSON.parse(hw1_json);

const hw_handler = new Handler(hw_json);

hw_handler.show_tasks();
hw_handler.show_level_labs();
hw_handler.show_input_requirements();
hw_handler.show_hints();
hw_handler.hide_autocheck();

// ans = hw_handler.get_ans();

function check(id, ans) {
  hw_handler.checker(id, ans[id])
}