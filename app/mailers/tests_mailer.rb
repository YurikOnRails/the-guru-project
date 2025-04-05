class TestsMailer < ApplicationMailer
    def completed_test(test_passage)
        @test_passage = test_passage
        @user = test_passage.user
        @test = test_passage.test

        mail to: @user.email, subject: "You completed the #{@test.title} test"
    end
end
