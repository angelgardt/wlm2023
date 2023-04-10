var info_json = JSON.parse(hw_json);


let info = {};
    
for (let i = 0; i < info_json.length; i++) {
    info[info_json[i].name] = {};
    if (info_json[i].name == "hints" || info_json[i].name == "hint_titles") {
        for (let t = 1; t <= N_TASKS; t++) {
            id = ID + "-" + t;
            info[info_json[i].name][id] = info_json[i][id].split("||");
        }
    } else {
        for (let t = 1; t <= N_TASKS; t++) {
            id = ID + "-" + t;
            info[info_json[i].name][id] = info_json[i][id];
        }
    }
}

console.log(info)

for (let id in info["task"]) {
  document.getElementById(id+"-task").innerHTML += info["task"][id]
}

for (let id in info["level"]) {
  document.getElementById(id+"-level").classList.add(info["level"][id]);
}

for (let id in info["input_requirements"]) {
  document.getElementById(id+"-ir").innerHTML += info["input_requirements"][id]
}

/*
info["hint_titles"].forEach(
  
)
*/




checker(id, ans)
  {
    let in_test = document.getElementById(id);
    let fb_test = document.getElementById(id+"-fb");
    if (in_test.value.trim() == "")
    {
      fb_test.style.display = "block";
      fb_test.innerHTML = "В поле ответа пусто :(";
      fb_test.style.color = "#4142CE";
    } else if (in_test.value.replaceAll(" ", "") == ans[id])
    {
      fb_test.style.display = "block";
      fb_test.innerHTML = "Верно!";
      fb_test.style.color = "#35D250";
    } else {
      fb_test.style.display = "block";
      fb_test.innerHTML = "Надо проверить вычисления…";
      fb_test.style.color = "#D33E36";
    }
  }