    let in_test1 = document.getElementById('in-test1');
    let fb_test1 = document.getElementById('fb-test1');
  
    function check_test1()
    {
      if (in_test1.value.trim() == "")
      {
        fb_test1.hidden = false;
        fb_test1.innerHTML = "В поле ответа пусто :(";
        fb_test1.style.color = "#4142CE";
      } else if (in_test1.value.trim().replaceAll(" ", "") == "1.23")
      {
        fb_test1.hidden = false;
        fb_test1.innerHTML = "Верно!";
        fb_test1.style.color = "#35D250";
      } else {
        fb_test1.hidden = false;
        fb_test1.innerHTML = "Надо проверить вычисления…";
        fb_test1.style.color = "#D33E36";
      }
    }