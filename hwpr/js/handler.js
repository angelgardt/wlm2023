class Handler {
  
  constructor(info_json, N_TASKS, ID) {
    this.info = this.jsonHandler(info_json, N_TASKS, ID);
    this.N_TASKS = N_TASKS;
    this.ID = ID;
    this.counter = this.createCounter();
  }
  
  jsonHandler(info_json, N_TASKS, ID) {
    let info = {};
    for (let i = 0; i < info_json.length; i++) {
      info[info_json[i].name] = {};
      for (let t = 1; t <= N_TASKS; t++) {
        id = ID + "-" + t;
        info[info_json[i].name][id] = info_json[i][id];
      }
    }
    return info
  }
  
  showLevelLabs(this.info) {
    for (let id in this.info["level"]) {
      document.getElementById(id+"-level").classList.add(info["level"][id]);
    }
  }
  
  hideAutocheck(this.info) {
    for (let id in this.info["has_autocheck"]) {
      if (info["has_autocheck"][id] == "False") {
        document.getElementById(id+"-autocheck").style.display = "none";
      }
    }
  }
  
  createCounter(this.info) {
    var counter = {};
    for (id in info["autocheck_answer"]) {
      counter[id] = 0;
    }
    return counter
  }
  
  showHints(id, this.counter) {
    if (counter[id] > 2) {
      document.getElementById(id+"-hints").style.display = "block";
    }
  }
  
  checker(id, ans, counter = this.counter) {
    let in_task = document.getElementById(id).value;
    let fb_task = document.getElementById(id+"-fb");
    if (in_task.trim() == "") 
    {
      fb_task.style.display = "block";
      fb_task.innerHTML = "В поле ответа пусто :(";
      fb_task.style.color = "#4142CE";
    } else if (in_task.replaceAll(" ", "") == ans)
    {
      fb_task.style.display = "block";
      fb_task.innerHTML = "Верно!";
      fb_task.style.color = "#35D250";
    } else {
      fb_task.style.display = "block";
      fb_task.innerHTML = "Надо проверить вычисления…";
      fb_task.style.color = "#D33E36";
      counter[id]++;
    }
    if (counter[id] > 2) {
      document.getElementById(id+"-hints").style.display = "block";
    }
  }
  
  check(id) {
    checker(id = id, ans = this.info["autocheck_answer"][id]);
  }
  
}
