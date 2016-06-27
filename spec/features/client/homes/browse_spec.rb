require 'rails_helper'

feature "User sees the home page", js: true do

  scenario 'they see the home info' do
    create(:author)
    posts = []
    4.times do |i|
      Timecop.freeze(i.days.ago)
      posts << create(:post, :accepted)
    end

    old_project = create(:project, :accepted)
    Timecop.return
    new_project = create(:project, :accepted)
    visit('/')
    3.times do |i|
      expect(page).to have_text(posts[i].title)
    end
    expect(page).not_to have_text(posts[3].title)
    expect(page).to have_css("img[src='#{new_project.image_url}']")
    expect(page).not_to have_css("img[src='#{old_project.image_url}']")
  end

  context 'when there are publishing posts' do
    scenario 'they click the all posts button' do
      create(:author)
      create(:post, :accepted)
      visit('/')
      click_link 'ALL POSTS'
      expect(page).to have_css('h1', 'Posts')
    end
  end

  context 'when there are no publishing posts' do
    scenario 'they cannot see the all posts button' do
      create(:author)
      visit('/')
      expect(page).not_to have_css('a', text: 'All POSTS')
    end
  end

  context 'when there are publishing projects' do
    scenario 'they click the all projects button' do
      create(:author)
      create(:project, :accepted)
      visit('/')
      click_link 'ALL PROJECTS'
      expect(page).to have_css('h1', 'Projects')
    end
  end

  context 'when there are no publishing projects' do
    scenario 'they cannot see the all projects button' do
      create(:author)
      visit('/')
      expect(page).not_to have_css('a', text: 'All PROJECTS')
    end
  end

end