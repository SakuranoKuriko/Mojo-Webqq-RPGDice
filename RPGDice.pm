package Mojo::Webqq::Plugin::RPGDice;
$Mojo::Webqq::Plugin::FuckDaShen::PRIORITY = 96;
sub rr{ rand($_[1]-$_[0])+$_[0] }
sub call{
    my $client = shift;
    $client->on(receive_message=>sub{
        my($client, $msg)=@_;
        return if not $msg->allow_plugin;
        return if $msg->content !~ /^\.r/;
        my $msgs = $msg->content;
        $msgs =~ s/\s+//g;
        my $reply = "";
        my $r = int rr(1,20);
        $reply .= $r;
        $client->reply_message($msg, $reply) if $reply;
        $msg->allow_plugin(0);
    });
}
1;
