/*
HOW TO SET KEYS IN ANS
hw<hw_n>-<task_n>, e.g. hw1-1
*/

var ans = {
  "hw1-1": "one",
  "hw1-2": "two",
  "hw1-3": "three",
  "hw1-4": "four",
  "hw1-5": "five",
  "hw1-6": "six",
  "hw1-7": "seven",
  "hw1-8": "eight",
  "hw1-9": "nine",
  "hw1-10": "ten",
  "hw1-11": "11",
  "hw1-12": "12",
  "hw1-13": "13",
  "hw1-14": "14",
  "hw1-15": "15"
};

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