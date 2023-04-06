function check(id)
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