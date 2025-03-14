defmodule GregslistWeb.UserLoginLive do
  use GregslistWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="relative flex-1 w-full h-screen bg-cover bg-center pt-20" style="background-image: url('/images/shopping.jpeg');">
      <div class="absolute inset-0 bg-black bg-opacity-50"></div>
      <div class="mx-auto max-w-sm p-10 rounded-lg shadow-lg relative z-10 bg-white bg-opacity-90">
        <div class="absolute inset-x-0 top-[-40px] flex justify-center">
          <div class="w-20 h-20 bg-teal-600 text-white rounded-full flex items-center justify-center overflow-hidden border-4 border-gray-100">
            <svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
              <title>login</title>
              <desc>Created with sketchtool.</desc>
              <g id="web-app" stroke-width="1" fill-rule="evenodd">
                <g id="login" fill="#FFFFFF">
                  <path d="M9.58578644,11 L7.05025253,8.46446609 L8.46446609,7.05025253 L13.4142136,12 L8.46446609,16.9497475 L7.05025253,15.5355339 L9.58578644,13 L3,13 L3,11 L9.58578644,11 Z M11,3 C16.3333333,3 19,3 19,3 C20.1000004,3 21,3.9000001 21,5 C21,5 21,19 21,19 C21,20.1000004 20.1000004,21 19,21 C19,21 16.3333333,21 11,21 L11,19 L19,19 L19,5 L11,5 L11,3 Z" id="Shape"></path>
                </g>
              </g>
            </svg>
          </div>
        </div>

        <h2 class="text-3xl font-bold text-center mb-6 text-teal-700 font-sans mt-8">Log In</h2>
        <hr class="border-b-2 border-teal-500 my-4" style="height: 2px;">

        <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore" class="space-y-6">
          <.input
            field={@form[:email]}
            type="email"
            label="Email"
            required
            class="border rounded-md px-4 py-2 w-full focus:ring-teal-500 focus:border-teal-500 font-sans"
          />
          <.input
            field={@form[:password]}
            type="password"
            label="Password"
            required
            class="border rounded-md px-4 py-2 w-full focus:ring-teal-500 focus:border-teal-500 font-sans"
          />

          <div class="flex justify-between items-center">
            <.input
              field={@form[:remember_me]}
              type="checkbox"
              label="Keep me logged in"
              class="font-sans"
            />
            <a href={~p"/users/reset_password"} class="text-sm text-teal-600 hover:underline font-sans">Forgot your password?</a>
          </div>

          <div class="text-center">
            <.button
              phx-disable-with="Logging in..."
              class="bg-teal-600 hover:bg-teal-700 text-white font-bold py-2 px-4 rounded w-full font-sans">
              Log In
            </.button>
          </div>
        </.simple_form>

        <br>
        <div class="text-center">
          Don't have an account?
          <.link navigate={~p"/users/register"} class="font-semibold text-teal-600 hover:underline text-teal-700 hover:text-teal-800">
            Sign up
          </.link>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
