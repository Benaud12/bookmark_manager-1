feature 'User sign up' do

  let(:user) {build :user}

  scenario 'I can sign up as an new user' do
    user = build :user
    expect { sign_up_as(user) }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, bob@bob.com')
    expect(User.first.email).to eq('bob@bob.com')
  end

  scenario 'requires a matching confirmation password' do
    user = build(:user, password_confirmation: 'wrong')
    expect { sign_up_as(user) }.not_to change(User, :count)
  end

  scenario 'with a password that does not match' do
    user = build(:user, password_confirmation: 'wrong')
    expect{ sign_up_as(user) }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Password and confirmation password do not match'
  end

  scenario 'requires an email to be entered' do
    user = build(:user, email: '')
    expect { sign_up_as(user) }.not_to change(User, :count)
  end

  def sign_up_as(user)
              # email: 'alice@example.com',
              # password: 'oranges!',
              # password_confirmation: 'oranges!')
    visit '/users/new'
    expect(page.status_code).to eq(200)
    fill_in :email,                 with: user.email
    fill_in :password,              with: user.password
    fill_in :password_confirmation, with: user.password_confirmation
    click_button 'Sign up'
  end

end
