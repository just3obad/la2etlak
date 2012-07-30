require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  setup :activate_authlogic

  ######Author : Diab######
    test "User Ranking red"
     interest = Interest.new(:name=>"whatever")
     interest.save
     user1 = User.new(:email=>"email1@mail.com", password: "12345678",password_confirmation:"12345678")
     user1.save
     user2 = User.new(:email=>"email2@mail.com", password: "12345678",password_confirmation:"12345678")
     user2.save
     user3 = User.new(:email=>"email3@mail.com", password: "12345678",password_confirmation:"12345678")
     user3.save
     story1 = Story.new(:title=>"Story1")
     story1.interest = interest
     story2 = Story.new(:title=>"Story2")
     story2.interest = interest
     assert_difference(user1.rank , 17) do
     user1.thumb_story(story1,1)
     user1.thumb_story(story2,-1)
     user1.share(story1.id)
     user1.flag_story(story2)
     c1 = Comment.new(:user_id=> user1.id , :story_id=>story.id , :content=>"LOL")
     c1.save
     user1.toggle_interests(interest)
     UserLogIn.create!(:user_id => user1.id)
     user1.invite(user2)
     user2.approve(user1)
     user3.block(user1)
     user1.get_user_rank
     end 
  end
  

##########Author: Diab ############ 
  test "top users red" do
     
     interest = Interest.new(:name=>"whatever")
     interest.save
     user1 = User.new(:email=>"email1@mail.com", password: "12345678",password_confirmation:"12345678" , name: "name1")
     user1.save
     user2 = User.new(:email=>"email2@mail.com", password: "12345678",password_confirmation:"12345678" , name: "name2")
     user2.save
     user3 = User.new(:email=>"email3@mail.com", password: "12345678",password_confirmation:"12345678" , name: "name3")
     user3.save
     story1 = Story.new(:title=>"Story1")
     story1.interest = interest
     story2 = Story.new(:title=>"Story2")
     story2.interest = interest)
     c1 = Comment.new(:user_id=> user1.id , :story_id=>story2.id , :content=>"LOL")
     c1.save
     user1.invite(user3)
     user3.approve(user1)
     user1.share(story1)
     user2.thumb_story(story2 , 1)
     User.rank_all_users
     top_stories_names = User.get_top_users_names
     top_stories_ranks = User.get_top_users_ranks
     assert_equal top_users_names , ["name1","name3","name2"]
     assert_equal top_users_ranks , [9,4,2]
    end

#Author : Shafei
  test "user get rank" do
	user = users(:one)
	story = stories(:one)
	comment = comments(:one)
	comment.user = user
	comment.story = story
	comment.save
	assert_equal(user.get_user_rank,7,"Action returns wrong number")
  end
  
    #Author : Shafei
  test "users get rank" do
  
	top_users = Array.new#
	top_users << users(:five)
	top_users << users(:four)
	top_users << users(:three)
	top_users << users(:two)
	top_users << users(:one)
	
	for i in 0...5
		assert_equal(top_users[i].id, User.get_users_ranking[i].id, "Ranking not correct")
	end
	
  end

  ##########Author: christinesed@gmail.com ############
  test "get no of users who signed in today one more user signed in today" do
    count=User.get_no_of_users_signed_in_today
    usr=User.new(:email=>"example@gmail.com", :password => "1234567", :password_confirmation => "1234567")
    assert usr.save
    log=UserLogIn.new
    log.user=usr
    assert log.save
    count2=User.get_no_of_users_signed_in_today
    assert_equal(count+1,count2)
  end

      #Author: Menisy
    test "should get shared stories" do
      user = users(:ben)
      assert user.get_shared_stories == [], "Should not have any shared stories initially"
      user.share(Story.first.id)
      assert user.get_shared_stories.length == 1, "Should have one shared story"
    end   

   ##########Author: christinesed@gmail.com ############
  test "get no of users who signed in today shouldn't add" do
    count=User.get_no_of_users_signed_in_today
     usr=User.new(:email=>"example@gmail.com", :password => "1234567", :password_confirmation => "1234567")
    assert usr.save
    log=UserLogIn.new
    log.user=usr
    log.created_at=2.days.ago
    assert log.save
    count2=User.get_no_of_users_signed_in_today
    assert_equal(count,count2)
  end

   ##########Author: christinesed@gmail.com ############
  test "get no of users who signed in today three more users signed in today" do
    count=User.get_no_of_users_signed_in_today
    usr=User.new(:email=>"example@gmail.com", :password => "1234567", :password_confirmation => "1234567")
    usr1=User.new(:email=>"example1@gmail.com", :password => "1234567", :password_confirmation => "1234567")
    usr2=User.new(:email=>"example2@gmail.com", :password => "1234567", :password_confirmation => "1234567")
    assert usr.save, "User can not be saved"
    assert usr1.save
    assert usr2.save
    log=UserLogIn.new
    log.user=usr
    assert log.save
    log=UserLogIn.new
    log.user=usr1
    assert log.save
    log=UserLogIn.new
    log.user=usr2
    assert log.save
    count2=User.get_no_of_users_signed_in_today
    assert_equal(count+3,count2)
  end

   ##########Author: christinesed@gmail.com ############
   test "get no of users who signed in today a user signed in more than once" do
   	count = User.get_no_of_users_signed_in_today
    usr=User.new(:email=>"example@gmail.com", :password => "1234567", :password_confirmation => "1234567")
    assert usr.save
    log=UserLogIn.new
    log.user=usr
    assert log.save
    log=UserLogIn.new
    log.user=usr
    assert log.save
    count2=User.get_no_of_users_signed_in_today
    assert_equal(count+1,count2)
  end
  

  #Author : Essam
  #Issue 90
  test "tumblr account" do
    ta = TumblrAccount.new
    ta.email = 'essamahmedhafez@gmail.com'
    ta.password = '12345678'
    feed = ta.get_feed
    assert !feed.nil?
    end
    
    
 #Author : Essam
 #issue 89
  test "get social networks feed" do
    user = User.new(:email=>"essamahmedhafez@gmail.com", :password => "12345678", :password_confirmation => "12345678")
    user.save
    user.twitter_account = twitter_accounts(:one)
    assert !user.twitter_account.nil?
    user_feed = user.twitter_account.get_feed()
    assert !user_feed.nil?
    user.facebook_account = facebook_accounts(:one)
    assert !user.facebook_account.nil?
    facebook_feed = user.facebook_account.get_feed
    assert !facebook_feed.nil?
    tumblr_test =  Tumblr::User.new('essamahmedhafez@gmail.com', '12345678')
    assert !tumblr_test.tumblr.nil?
    blog = tumblr_test.tumblr["tumblelog"]["name"]
    assert blog = 'essamhafez'
    Tumblr.blog = 'essamhafez'
    posts = Tumblr::Post.all
    assert !posts.nil?
  end
  
  #Author : Essam
  #Issue 88
  test "filter selected social account" do
    user = User.new
    user.email = 'essam@hafez.com'
    user.twitter_account = twitter_accounts(:one)
    user_feed = user.twitter_account.get_feed()
    assert !user_feed.nil?
  end
  

	#Author : Kareem
	test "create new flag" do
  	i = Interest.create(:name => "Smart")
	u = User.create(:email => "bwqer@a.com" , :password => "123456" , :password_confirmation => "123456")
 	s = Story.create(:title => "lol" , :interest_id => i.id)
  	assert_difference('Flag.count') do
	u.flag_story(s) 	
	end
	end
	
	#Author : Kareem
	test "try flagged user" do
	i = Interest.create(:name => "Smart1")
	u1 = User.create(:email => "bwqwer@a.com" , :password => "123456" , :password_confirmation => "123456")
	s = Story.create(:title => "hashas" , :interest_id => i.id)
 	Flag.create(:user_id => u1.id , :story_id =>s.id)
	assert_no_difference('Flag.count') do
	u1.flag_story(s)
	end
     end 

       

 

	#Author : Kareem 			
	test "new thumb story" do
	user = User.create(:email => "a@a.com" , :password => "123456" , :password_confirmation => "123456")
	i = Interest.create(:name => "rare")
	s = Story.create(:title => "ahaaaa" , :interest_id => i.id)
	assert_difference('Likedislike.count') do
	user.thumb_story(s,1)
	end
	end
	#$$$$$$$$
	#Author : Kareem
	test "thumb story again" do
	user = User.create(:email => "b@a.com" , :password => "123456" , :password_confirmation => "123456")
	i = Interest.create(:name => "rares")
	s = Story.create(:title => "ahaaaa" , :interest_id => i.id)
	Likedislike.create(:user_id => user.id , :story_id => s.id ,:action => 1)
	assert_no_difference('Likedislike.count') do
	user.thumb_story(s,-1)
	end
	end

	#Author : Kareem
	test "should return stories" do
	user = User.create(:email => "baa@a.com" , :password => "123456" , :password_confirmation => "123456")
	i= Interest.create(:name => "Art")
	s= Story.create(:title => "hahsd" , :interest_id => i.id)
	UserAddInterest.create(:user_id => user.id , :interest_id => i.id)
	stories = user.get_feed()
	assert_not_nil stories
	assert_equal stories[0].class.name , "Story" , "Return must be of class story"
	end


        #Author : Kareem
	test "should return user interests" do
	user = User.create(:email => "basa@a.com" , :password => "123456" , :password_confirmation => "123456")
	i = Interest.create(:name => "Ball")
     	i1 =  user.get_interests
	i2 = UserAddInterest.find(:all , :conditions => ["user_id = ?" , user.id ] , :select => "interest_id").map {|interest| interest.interest_id}.map {|id| 		   		Interest.find(id).name} 
 	assert_equal i1 , i2	, "User Interests must be returned"
	end

    
    #Author : Omar 
    #$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

	test "add or delete interest" do
	
		user = users(:ben)
		UserSession.create(user)
		int1 = Interest.create(:name => "interest 1")
		user.toggle_interests(int1.id)
		assert_equal( user.added_interests , [int1]  , "interest is not added")
		user.toggle_interests(int1.id)
		assert_equal( user.added_interests , []  , "interest is not deleted")
	
	end
	
	

   #$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 
    

	

    #Author: Rana
    test "interest should be blocked" do
      this_interest = Interest.create :name => "Sports", :description => "hey sporty"
      this_user = users(:ben)
      UserSession.create(this_user)
      assert_difference('BlockInterest.count',1,"Interest blocked.") do
         this_user.block_interest1(this_interest)
      end
      assert_difference('BlockInterest.count', 0, "Interest is already blocked.") do
         this_user.block_interest1(this_interest)
      end
    end


    #Author: Rana
   test "story should be blocked" do
      this_interest = Interest.create :name => "Sports", :description => "hey sporty"
      this_story= Story.new :title => "Story1", :interest_id => this_interest
      this_story.interest = this_interest
      this_story.save
      this_user = users(:ben)
      UserSession.create(this_user)
      assert_difference('BlockStory.count',1,"Story blocked.") do
         this_user.block_story1(this_story)
      end
      assert_difference('BlockStory.count', 0,"Story is already blocked.") do
         this_user.block_story1(this_story)
      end
    end

    #Author: Rana
   test "should block friend feed" do
      this_user = users(:ben)
      UserSession.create(this_user)
      my_friend = users(:ahmed)
      this_user.invite my_friend
      my_friend.approve this_user
      assert_equal("#{my_friend.email} blocked.",  			this_user.block_friends_feed1(my_friend),"#{my_friend.email} blocked.")
      assert_equal("#{my_friend.email} is already blocked.", this_user.block_friends_feed1(my_friend), "#{my_friend.email} is already blocked.")
    end

    #Author: Rana
   test "should unblock friend feed" do
      this_user = users(:ben)
      UserSession.create(this_user)
      my_friend = users(:ahmed)
      this_user.invite my_friend
      my_friend.approve this_user
      this_user.block my_friend
      assert_equal("#{my_friend.email} unblocked." , this_user.unblock_friends_feed1(my_friend), "#{my_friend.email} unblocked.")
      assert_equal("#{my_friend.email} is already unblocked." , this_user.unblock_friends_feed1(my_friend), "#{my_friend.email} is already unblocked.")
    end

   #Author: Rana
   test "story should be unblocked" do
      this_user = users(:ben)
      UserSession.create(this_user)
      this_interest = Interest.create :name => "Sports", :description => "hey sporty"
      this_story= Story.new :title => "Story1", :interest_id => this_interest
      this_story.interest = this_interest
      this_story.save
      this_user.block_story1(this_story)
      assert_equal("Story unblocked.", this_user.unblock_story1(this_story), "Story unlbocked.")
      assert_equal("Story is already unblocked.", this_user.unblock_story1(this_story), "Story is already unlbocked.")
    end

 #Author: Rana
   test "interest should be unblocked" do
      this_user = users(:ben)
      UserSession.create(this_user)
      this_interest = Interest.create :name => "Sports", :description => "hey sporty"
      this_user.block_interest1(this_interest)
      assert_equal("Interest unblocked.", this_user.unblock_interest1(this_interest), "Story unlbocked.")
      assert_equal("Interest is already unblocked.", this_user.unblock_interest1(this_interest), "Interest is already unlbocked.")
    end


   #Author: Rana
   test "should return blocked story list" do
      this_user = users(:ben)
      UserSession.create(this_user)
      this_interest = Interest.create :name => "Sports", :description => "hey 		sporty"
      this_story= Story.new :title => "Story1", :interest_id => this_interest
      this_story.interest = this_interest
      this_story.save
      this_user.blocked_stories << this_story
      blocked_stories = this_user.blocked_stories 
      assert_equal(blocked_stories, this_user.get_blocked_stories, "List returned 	successfully.")
    end

	#Author: Kiro
	test "should not save a user without any parameters" do
		user = User.new
		assert !user.save, "saved a user without any parameters"
	end

	#Auther: Kiro
	test "should not save a user without a password" do
		user = User.new
		user.email = "email_1@test.com"
		assert !user.save, "saved a user without a password"
	end
	
	#Auther: Kiro
	test "shouldn't save a user with mismatching password confirmation" do
		user = User.new(email: "email_2@test.com",password: "123456",password_confirmation:"abcdet")
		assert !user.save, "saved a user with mismatching password confirmation"
	end

	#Auther: Kiro
	test "password should be 6 characters or more" do

		user = User.new(email: "pass0@test.com",password: "",password_confirmation:"")
		assert !user.save, "saved a user with passowrd of length 0"

		user = User.new(email: "pass1@test.com",password: "1",password_confirmation:"1")
		assert !user.save, "saved a user with passowrd of length 1"
		
		user = User.new(email: "pass5@test.com",password: "12345",password_confirmation:"12345")
		assert !user.save, "saved a user with passowrd of length 5"

		user = User.new(email: "pass6@test.com",password: "123456",password_confirmation:"123456")
		assert user.save, "didn't save a user with password length 6"

		user = User.new(email: "pass7@test.com",password: "1234567",password_confirmation:"1234567")
		assert user.save, "didn't save a user with password length 7"	
		
	end

	#Auther: Kiro
	test "should not save a user without a password confirmation" do
		user = User.new
		user.email = "email_1@test.com"
		user.password = "123456"
		assert !user.save, "saved a user without password confirmation"
	end

	#Author: Kiro
	test "Should not save a user with an existing email" do
	
		user = User.new(email: "only_one@test.com", password:"123456", password_confirmation:"123456")
		assert user.save, "didn't save the first user"
	
		user = User.new(email: "only_one@test.com", password:"123456", password_confirmation:"123456")
		assert !user.save, "saved a user with an existing email"

	end

	#Author: Kiro
	test "should not accept an email in a wrong format" do
	
		user = User.new(email: "correct_format@test.com", password:"123456", password_confirmation:"123456")
		assert user.save, "didn't accept an email in a correct format"

		user.email = ""
		assert !user.save, "saved a user with a wrong email --> empty string "

		user.email = "fail_format1"
		assert !user.save, "saved a user with a wrong email --> fail_format1"

		user.email = "fail_format2.com"
		assert !user.save, "saved a user with a wrong email --> fail_format2.com"

		user.email = "fail_format3@com"
		assert !user.save, "saved a user with a wrong email --> fail_format3@com"

		user.email = "@failformat4"
		assert !user.save, "saved a user with a wrong email --> @failformat4"

		user.email = "fail/format5@test.com"
		assert !user.save, "saved a user with a wrong email --> fail/format5@test.com"

		user.email = "+@failformat6.com"
		assert !user.save, "saved a user with a wrong email --> +@failformat6.com"

		user.email = "fail_format7@fail_format7.com"
		assert !user.save, "saved a user with a wrong email --> fail_format7@fail_format7.com"

		user.email = "correct_format@correctformat.com"
		assert user.save, "didn't save an email in the correct format"
		
	end

	test "extract friends" do 
		u1 = users(:one)
		u2 = users(:two)
		u1.invite u2
		u2.approve u1
		users = [users(:one), users(:two), users(:three), users(:four)]
		result = u1.extract_friends(users)
		assert result.include?(u2), 'User 2 should be in the result'
		assert !result.include?( users(:three)), 'User three should not be in the result'
	end 
  
	  #Author: Bassem
    test "deactivating users" do
    @usr=User.create!(:email=>"exampleuserpage@gmail.com", :password => "1234567", :password_confirmation => "1234567")
    @usr.deactivate_user
  	assert @usr.deactivated
end
 #Author: Bassem
    test "activating users" do
    @usr=User.create!(:email=>"exampleuserpage@gmail.com", :password => "1234567", :password_confirmation => "1234567")
    @usr.activate_user
  	assert !@usr.deactivated
end

	#Author: Kiro
	test "reset password adds a value to new password field" do

		ben = users(:ben)
		ben.resetPassword
		assert_not_nil ben.new_password	

	end

	#Author: Kiro
	test "after resetting password the new password can be used for login" do

		ben = users(:ben)
		ben.resetPassword
		assert UserSession.create(:email => "ben@gmail.com", :password => ben.new_password), "cannot use new password"

	end

	#Author: Kiro
	test "after resetting password the old password can be used for login" do

		ben = users(:ben)
		ben.resetPassword
		assert UserSession.create(:email => "ben@gmail.com", :password => "benrocks"), "cannot use old password"

	end

  #Kareem New
  test "cannot send twice" do
    toto = User.create!(:email=>"tesssst@test.com" , :password => "12345678" , :password_confirmation => "12345678")
    flag = toto.send_feedback("Message")
    flag1 = toto.send_feedback("hahahaha")
    assert_not_equal flag,flag1,"User Can't Send Feedback twice in 10 days"
  end


  #Kareem New
  test "feedback should be added to table" do
    toty = User.create(:email=>"tote@test.com" , :password => "12345678" , :password_confirmation => "12345678")
    toty.send_feedback("hahahahaha")
    flag = Feedback.find_by_user_id(toty.id)
    assert_not_nil flag , "User Feedback should be added to Feedback table"
end

####Mazmoz#
  test "user has a gender" do
    count=User.get_no_of_users_signed_in_today
     usr=User.new(:email=>"example@gmail.com", :password => "1234567", :password_confirmation => "1234567")
     usr.gender = "male"
    assert usr.save
  end
#<<<<<<< HEAD

#Kareem
test "query should return friend" do
  	toti =User.create(:email=>"toti@test.com" , :password => "12345678" , :password_confirmation => "12345678")
  	hseen = User.create(:email => "se7s@test.com", :password => "123456",:password_confirmation => "123456")
  	Friendship.create(:user_id => toti.id , :friend_id => hseen.id)
  	list = toti.search_friends("se7s")
  	flag = false
  	list.each do |friend|
  		if (friend == hseen)
  			flag = true
  		end
  	end
  	assert flag , "Method should return the Friends i searched for by Email Prefix or name"
  	assert_equal lists[0].class.name , "User" , "should return Objects of class User"

end

test "should return profile pic" do

 tata = User.create(:email => "tata@tata.com" , :password => "123456" , :password_confirmation => "123456" , :image => "adel.jpg")
 assert_equal tata.get_profile_pic , "adel.jpg" , "Profile pic should be the same as the uploaded pp"
end

  
  
    # Omar  
#########################################################
  
  test "friend request notification RED" do
        ben = users(:ben)
	UserSession.create(ben)
        ahmed = users(:ahmed)
        UserSession.create(ahmed)
        	     
        assert_equal(Noitification.last.type,1,"friendship request sent notification entered database correctly")
        end
  
  test "friend request accepeted notification RED" do
	ben = users(:ben)
	UserSession.create(ben)
        ahmed = users(:ahmed)
        UserSession.create(ahmed)
        
        assert_equal(Noitification.last.type,2,"friendship accepted notification entered database correctly")  	
  end  

  test "recommend story notification RED" do
  	ben = users(:ben)
	UserSession.create(ben)
        ahmed = users(:ahmed)
        UserSession.create(ahmed)
        
        assert_equal(Noitification.last.type,3,"friend recommend a story notification entered database correctly")  	

  end
  
  test "comment on friend comment notification RED" do
	ben = users(:ben)
	UserSession.create(ben)
        ahmed = users(:ahmed)
        UserSession.create(ahmed)
        interest  = Interest.create(name:"interest 1")
        story = Story.create(interest_id: interest.id , title:"story title" , media_link:"http://www.omar.com")
        comment1 = Comment.create(user_id: ben.id ,story_id: story.id , content:"1")
        comment2 = Comment.create(user_id: ahmed.id ,story_id: story.id , content:"2")
        assert_equal(Noitification.last.type,4,"friend comment on story i commented on notification entered database correctly")  	
  
  end
  
  test "like comment notification RED" do
	ben = users(:ben)
	UserSession.create(ben)
        ahmed = users(:ahmed)
        UserSession.create(ahmed)
        interest  = Interest.create(name:"interest 1")
        story = Story.create(interest_id: interest.id , title:"story title" , media_link:"http://www.omar.com")
        comment1 = Comment.create(user_id: ben.id ,story_id: story.id , content:"1")
        CommentUpDown.create(action: 1 , user_id: ben.id , comment_id: comment1.id)
        assert_equal(Noitification.last.type,5,"friend like comment notification entered database correctly")  	
  
  end    

  test "dislike your notification RED" do
  	ben = users(:ben)
	UserSession.create(ben)
        ahmed = users(:ahmed)
        UserSession.create(ahmed)
        interest  = Interest.create(name:"interest 1")
        story = Story.create(interest_id: interest.id , title:"story title" , media_link:"http://www.omar.com")
        comment1 = Comment.create(user_id: ben.id ,story_id: story.id , content:"1")
	CommentUpDown.create(action: 2 , user_id: ben.id , comment_id: comment1.id)
        assert_equal(Noitification.last.type,6,"friend dislike comment notification entered database correctly")
  end
#########################################################
  
  
#>>>>>>> b3925240852892f2d8431399fc0f2d5bafeefb2d
end
