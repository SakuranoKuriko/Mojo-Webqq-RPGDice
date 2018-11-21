package Mojo::Webqq::Plugin::RPGDice;
$Mojo::Webqq::Plugin::FuckDaShen::PRIORITY = 96;
#our $AUTO_CALL = 0;
sub rr{ rand($_[1]-$_[0])+$_[0] }
sub call{
    my $client = shift;
    $client->on(receive_message=>sub{
        my($client, $msg)=@_;
        return if not $msg->allow_plugin;
        return if $msg->content !~ /^\.r/;
        my r = int rr(1,20);
        #my $key_word = $1;$key_word=~s/\s+//;
        #my $reply = $reply[int rand($#reply+1)];
        #$reply=~s/%/$key_word/g;
        #$client->reply_message($msg,$reply,sub{$_[1]->from("bot")}) if $reply;
        $client->reply_message($msg, "hello world");
        $msg->allow_plugin(0);
    });
}
1;
