package Mojo::Webqq::Plugin::RPGDice;
$Mojo::Webqq::Plugin::FuckDaShen::PRIORITY = 96;
#our $AUTO_CALL = 0;
sub rr{ rand($_[1]-$_[0])+$_[0] }
sub rollnow{
    my $count = int $_[0],
       $sided = int $_[1],
       $correction = int $_[2],
       $multi = int $_[3],
       $msg = $_[4],
       $user = $_[5];
    my $ret = "<" . $user .">: ". $msg . "\n扔出骰子：";
    my $sum=0, $sumrow, $t;
    if ($multi < 2){
        $multi = 1;
    }
    else {
        $ret .= "\n";
    }
    for (my $m = 0; $m < $multi; $m++){
        if ($count == 1){
            $t = int(rr(1, $sided));
            $ret .= $t;
            $ret .= $correction<0?"":"+" . $correction if $correction!=0;
            $sum += $t + $correction;
        }
        else {
            $sumrow = 0;
            for (my $i = 0; $i < $count; $i++){
                $t = int(rr(1, $sided));
                $ret .= $t . ", ";
                $sumrow += $t;
            }
            $ret = substr($ret, 0, -2) . " -> " . $sumrow;
            $sumrow += $correction;
            $ret .= $correction<0?"":"+" . $correction . " = " . $sumrow if $correction!=0;
            $sum += $sumrow;
        }
        $ret .= "\n";
    }
    return $ret . "总和：" . $sum if $multi >1;
    return substr($ret, 0, -1);
}
sub roll{
    my $c = 1,
       $s = 20,
       $a = 0,
       $m = 1,
       $user = $_[0],
       $cmd = lc $_[1];
    $cmd =~ s/\s+//g;
    return "示例 丢1个20面骰子，得数+2，重复3次\r\n指令 .r1d20+2*3" if $cmd =~ /^\.r[\s?help]+$/;
    if ($cmd ne ".r"){
        $c = int $1 if $cmd =~ /^\.r([\d]+)/;
        $s = int $1 if $cmd =~ /d([\d]+)/;
        $a = int $1 if $cmd =~ /([+-][\d]+)/;
        $m = int $1 if $cmd =~ /\*([\d]+)/;
    }
    return rollnow($c, $s, $a, $m, $_[1], $user);
}
sub call{
    my $client = shift;
    $client->on(receive_message=>sub{
        my($client, $msg)=@_;
        return if not $msg->allow_plugin;
        return if $msg->time()+5<time();
        return if $msg->content !~ /^\.[rR]/;
        $client->reply_message($msg, roll($msg->sender->displayname, $msg->content));
        $msg->allow_plugin(0);
    });
}
1;
