var info_json = JSON.parse(hw_json);


let info = {};
    
for (let i = 0; i < info_json.length; i++) {
  info[info_json[i].name] = {};
  for (let t = 1; t <= N_TASKS; t++) {
    id = ID + "-" + t;
    info[info_json[i].name][id] = info_json[i][id];
  }
}

console.log(info)

for (let id in info["level"]) {
  document.getElementById(id+"-level").classList.add(info["level"][id]);
}

for (let id in info["has_autocheck"]) {
  if (info["has_autocheck"][id] == "False") {
    document.getElementById(id+"-autocheck").style.display = "none";
  }
}


var counter = {};
for (let id in info["autocheck_answer"]) {
  counter[id] = 0;
}

function checker(id, ans)
  {
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

function check(id) {
  checker(id = id, ans = info["autocheck_answer"][id]);
}
