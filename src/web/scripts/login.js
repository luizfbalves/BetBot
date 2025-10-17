console.log("🚀 login.js carregado");

// Verificar se Eel está pronto
eel.set_host("ws://localhost:8000");
console.log("🔌 Eel host configurado");

// Testar conexão com Eel
eel.ping()((result) => {
  console.log("🏓 Eel ping result:", result);
});

welcome();

function shakeInputs() {
  const shakeAnimation = [
    [
      { transform: "translateX(0px)" },
      { transform: "translateX(-10px)" },
      { transform: "translateX(10px)" },
      { transform: "translateX(0px)" },
    ],
    { duration: 150, iterations: 2 },
  ];

  username.parentElement.animate(shakeAnimation[0], shakeAnimation[1]);
  password.parentElement.animate(shakeAnimation[0], shakeAnimation[1]);
}

function open_login() {
  const blur = document.querySelector(".blur");
  const login = document.querySelector(".login-panel");
  blur.style.display = "block";
  login.style.transform = "translateY(0)";
}

function close_login() {
  const blur = document.querySelector(".blur");
  const login = document.querySelector(".login-panel");
  blur.style.display = "none";
  login.style.transform = "translateY(-300px)";
}

function handle_register() {
  const username = document.querySelector("#new_username").value;
  const password = document.querySelector("#new_password").value;
  const confirmPassword = document.querySelector("#confirm_password").value;

  const account = {
    username: username,
    password: password,
    confirm_password: confirmPassword,
  };

  console.log("🔐 Tentando cadastrar:", account.username);

  eel.handle_register(account)((result) => {
    console.log("📥 Resposta do cadastro:", result);

    if (result.success) {
      console.log("✅ Cadastro bem-sucedido");
      alert(result.message);
      close_register();
      // Limpar campos
      document.querySelector("#new_username").value = "";
      document.querySelector("#new_password").value = "";
      document.querySelector("#confirm_password").value = "";
    } else {
      console.log("❌ Cadastro falhou:", result.message);
      alert("Erro: " + result.message);
    }
  });
}

function show_register() {
  console.log("📝 Mostrando painel de cadastro");
  document.querySelector(".register-container .blur").style.display = "block";
  document.querySelector(".register-panel").classList.add("show");
}

function close_register() {
  console.log("❌ Fechando painel de cadastro");
  document.querySelector(".register-container .blur").style.display = "none";
  document.querySelector(".register-panel").classList.remove("show");
}

function cleanup_new_username() {
  document.querySelector("#new_username").value = "";
}

function cleanup_username() {
  const username = document.querySelector("#username");
  username.value = "";
}

function fill_field(css_selector, value) {
  document.querySelector(css_selector).textContent = value;
}

function login(account) {
  localStorage.setItem("account", JSON.stringify(account));
  document.querySelectorAll(".logout").forEach((item) => {
    item.style.display = "none";
  });
  document.querySelectorAll(".login").forEach((item) => {
    item.style.display = "flex";
  });

  close_login();
}

function handle_login() {
  const username = document.querySelector("#username");
  const password = document.querySelector("#password");

  if (username.value === "" || password.value === "") {
    shakeInputs();
    return;
  }

  const account = {
    username: username.value,
    password: password.value,
  };
  username.value = "";
  password.value = "";

  console.log("🔐 Tentando login com:", account.username);

  eel.handle_login(account)((result) => {
    console.log("📥 Resposta do login:", result);
    if (!result) {
      console.log("❌ Login falhou - result é falso");
      shakeInputs();
    } else {
      console.log("✅ Login bem-sucedido, chamando login() com:", result);
      login(result);
    }
  });
}

function logout() {
  localStorage.removeItem("account");
  toggle_user_container();

  document.querySelectorAll(".logout").forEach((item) => {
    item.style.display = "flex";
  });
  document.querySelectorAll(".login").forEach((item) => {
    item.style.display = "none";
  });
  welcome();
}
