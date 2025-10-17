eel.expose(updateBalance);
function updateBalance(balance) {
  balance = balance.toFixed(2);
  fill_field("#actual_value", `R$${balance}`);
  fill_field("#actual_value2", `R$${balance}`);
}
eel.expose(sessionGain);
function sessionGain(balance) {
  balance = balance.toFixed(2);
  fill_field("#actual_value", `R$${balance}`);
}
