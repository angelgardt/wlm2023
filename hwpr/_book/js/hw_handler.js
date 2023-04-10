import { Handler } from './handler.js';

var hw_json_parced = JSON.parse(hw_json);

const handler = new Handler(hw_json_parced, N_TASKS, ID);

handler.showLevelLabs();
handler.hideAutocheck();
