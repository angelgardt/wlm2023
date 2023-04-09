export class Handler {
  constructor(hw_json) {
    this.hw_json = this.jsonHandler(hw_json);
  }
  
  jsonHandler(hw_json) {
    let handled_json = {};
    let ntasks = hw_json.length;
    
    for (let i = 0; i < ntasks; i++) {
      handled_json.set(hw_json[i][0], 
      Object.fromEntries(Object.entries(hw_json[i]).slice(1, ntasks)));
    }
    return handled_json
  }
  
  showTasks() {
    let tasks = this.hw_json["task"]
    for (let id in tasks) {
      document.getElementById(id+"-task").innerHTML = tasks[id]
    }
  }
  
  showLevelLabs() {
    
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

