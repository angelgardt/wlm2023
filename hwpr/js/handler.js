export class Handler {
  constructor(info_json, N_TASKS, ID) {
    this.info = this.jsonHandler(info_json);
    this.N_TASKS = N_TASKS;
    this.ID = ID
  }
  
  jsonHandler(info_json) {
    let info = {};
    
    for (let i = 0; i < info_json.length; i++) {
      info[info_json[i].name] = {};
      if (info_json[i].name == "hints" || hw_json[i].name == "hint_titles") {
          for (let t = 1; t <= this.N_TASKS; t++) {
              id = ID + "-" + t;
              hw_info[hw_json[i].name][id] = hw_json[i][id].split("||");
          }
      } else {
          for (let t = 1; t <= this.N_TASKS; t++) {
              id = this.ID + t;
              handled_json[hw_json[i].name][id] = hw_json[i][id];
          }
      }
  }
    return info
  }
  
  showTasks() {
    for (let id in this.info["task"]) {
      document.getElementById(id+"-task").innerHTML += this.info["task"][id]
    }
  }
  
  showLevelLabs() {
    for (let id in this.info["level"]) {
      document.getElementById(id+"-complexity").innerHTML += this.info["task"][id]
    }
  }
  
  showInputRequirements() {
    
  }
  
  showHints() {
    
  }
  
  hideAutocheck() {
    
  }
  
  
  checker(id, ans)
  {
    let in_test = document.getElementById(id);
    let fb_test = document.getElementById('fb-'+id);
    if (in_test.value.trim() == "")
    {
      fb_test.hidden = false;
      fb_test.innerHTML = "В поле ответа пусто :(";
      fb_test.style.color = "#4142CE";
    } else if (in_test.value.replaceAll(" ", "") == ans[id])
    {
      fb_test.hidden = false;
      fb_test.innerHTML = "Верно!";
      fb_test.style.color = "#35D250";
    } else {
      fb_test.hidden = false;
      fb_test.innerHTML = "Надо проверить вычисления…";
      fb_test.style.color = "#D33E36";
    }
  }
}

