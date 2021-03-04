
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "iput test\n");
       6:	a1 a8 62 00 00       	mov    0x62a8,%eax
       b:	83 ec 08             	sub    $0x8,%esp
       e:	68 0a 44 00 00       	push   $0x440a
      13:	50                   	push   %eax
      14:	e8 25 40 00 00       	call   403e <printf>
      19:	83 c4 10             	add    $0x10,%esp

  if(mkdir("iputdir") < 0){
      1c:	83 ec 0c             	sub    $0xc,%esp
      1f:	68 15 44 00 00       	push   $0x4415
      24:	e8 0a 3f 00 00       	call   3f33 <mkdir>
      29:	83 c4 10             	add    $0x10,%esp
      2c:	85 c0                	test   %eax,%eax
      2e:	79 1b                	jns    4b <iputtest+0x4b>
    printf(stdout, "mkdir failed\n");
      30:	a1 a8 62 00 00       	mov    0x62a8,%eax
      35:	83 ec 08             	sub    $0x8,%esp
      38:	68 1d 44 00 00       	push   $0x441d
      3d:	50                   	push   %eax
      3e:	e8 fb 3f 00 00       	call   403e <printf>
      43:	83 c4 10             	add    $0x10,%esp
    exit();
      46:	e8 80 3e 00 00       	call   3ecb <exit>
  }
  if(chdir("iputdir") < 0){
      4b:	83 ec 0c             	sub    $0xc,%esp
      4e:	68 15 44 00 00       	push   $0x4415
      53:	e8 e3 3e 00 00       	call   3f3b <chdir>
      58:	83 c4 10             	add    $0x10,%esp
      5b:	85 c0                	test   %eax,%eax
      5d:	79 1b                	jns    7a <iputtest+0x7a>
    printf(stdout, "chdir iputdir failed\n");
      5f:	a1 a8 62 00 00       	mov    0x62a8,%eax
      64:	83 ec 08             	sub    $0x8,%esp
      67:	68 2b 44 00 00       	push   $0x442b
      6c:	50                   	push   %eax
      6d:	e8 cc 3f 00 00       	call   403e <printf>
      72:	83 c4 10             	add    $0x10,%esp
    exit();
      75:	e8 51 3e 00 00       	call   3ecb <exit>
  }
  if(unlink("../iputdir") < 0){
      7a:	83 ec 0c             	sub    $0xc,%esp
      7d:	68 41 44 00 00       	push   $0x4441
      82:	e8 94 3e 00 00       	call   3f1b <unlink>
      87:	83 c4 10             	add    $0x10,%esp
      8a:	85 c0                	test   %eax,%eax
      8c:	79 1b                	jns    a9 <iputtest+0xa9>
    printf(stdout, "unlink ../iputdir failed\n");
      8e:	a1 a8 62 00 00       	mov    0x62a8,%eax
      93:	83 ec 08             	sub    $0x8,%esp
      96:	68 4c 44 00 00       	push   $0x444c
      9b:	50                   	push   %eax
      9c:	e8 9d 3f 00 00       	call   403e <printf>
      a1:	83 c4 10             	add    $0x10,%esp
    exit();
      a4:	e8 22 3e 00 00       	call   3ecb <exit>
  }
  if(chdir("/") < 0){
      a9:	83 ec 0c             	sub    $0xc,%esp
      ac:	68 66 44 00 00       	push   $0x4466
      b1:	e8 85 3e 00 00       	call   3f3b <chdir>
      b6:	83 c4 10             	add    $0x10,%esp
      b9:	85 c0                	test   %eax,%eax
      bb:	79 1b                	jns    d8 <iputtest+0xd8>
    printf(stdout, "chdir / failed\n");
      bd:	a1 a8 62 00 00       	mov    0x62a8,%eax
      c2:	83 ec 08             	sub    $0x8,%esp
      c5:	68 68 44 00 00       	push   $0x4468
      ca:	50                   	push   %eax
      cb:	e8 6e 3f 00 00       	call   403e <printf>
      d0:	83 c4 10             	add    $0x10,%esp
    exit();
      d3:	e8 f3 3d 00 00       	call   3ecb <exit>
  }
  printf(stdout, "iput test ok\n");
      d8:	a1 a8 62 00 00       	mov    0x62a8,%eax
      dd:	83 ec 08             	sub    $0x8,%esp
      e0:	68 78 44 00 00       	push   $0x4478
      e5:	50                   	push   %eax
      e6:	e8 53 3f 00 00       	call   403e <printf>
      eb:	83 c4 10             	add    $0x10,%esp
}
      ee:	90                   	nop
      ef:	c9                   	leave  
      f0:	c3                   	ret    

000000f1 <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      f1:	55                   	push   %ebp
      f2:	89 e5                	mov    %esp,%ebp
      f4:	83 ec 18             	sub    $0x18,%esp
  int pid;

  printf(stdout, "exitiput test\n");
      f7:	a1 a8 62 00 00       	mov    0x62a8,%eax
      fc:	83 ec 08             	sub    $0x8,%esp
      ff:	68 86 44 00 00       	push   $0x4486
     104:	50                   	push   %eax
     105:	e8 34 3f 00 00       	call   403e <printf>
     10a:	83 c4 10             	add    $0x10,%esp

  pid = fork();
     10d:	e8 b1 3d 00 00       	call   3ec3 <fork>
     112:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
     115:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     119:	79 1b                	jns    136 <exitiputtest+0x45>
    printf(stdout, "fork failed\n");
     11b:	a1 a8 62 00 00       	mov    0x62a8,%eax
     120:	83 ec 08             	sub    $0x8,%esp
     123:	68 95 44 00 00       	push   $0x4495
     128:	50                   	push   %eax
     129:	e8 10 3f 00 00       	call   403e <printf>
     12e:	83 c4 10             	add    $0x10,%esp
    exit();
     131:	e8 95 3d 00 00       	call   3ecb <exit>
  }
  if(pid == 0){
     136:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     13a:	0f 85 92 00 00 00    	jne    1d2 <exitiputtest+0xe1>
    if(mkdir("iputdir") < 0){
     140:	83 ec 0c             	sub    $0xc,%esp
     143:	68 15 44 00 00       	push   $0x4415
     148:	e8 e6 3d 00 00       	call   3f33 <mkdir>
     14d:	83 c4 10             	add    $0x10,%esp
     150:	85 c0                	test   %eax,%eax
     152:	79 1b                	jns    16f <exitiputtest+0x7e>
      printf(stdout, "mkdir failed\n");
     154:	a1 a8 62 00 00       	mov    0x62a8,%eax
     159:	83 ec 08             	sub    $0x8,%esp
     15c:	68 1d 44 00 00       	push   $0x441d
     161:	50                   	push   %eax
     162:	e8 d7 3e 00 00       	call   403e <printf>
     167:	83 c4 10             	add    $0x10,%esp
      exit();
     16a:	e8 5c 3d 00 00       	call   3ecb <exit>
    }
    if(chdir("iputdir") < 0){
     16f:	83 ec 0c             	sub    $0xc,%esp
     172:	68 15 44 00 00       	push   $0x4415
     177:	e8 bf 3d 00 00       	call   3f3b <chdir>
     17c:	83 c4 10             	add    $0x10,%esp
     17f:	85 c0                	test   %eax,%eax
     181:	79 1b                	jns    19e <exitiputtest+0xad>
      printf(stdout, "child chdir failed\n");
     183:	a1 a8 62 00 00       	mov    0x62a8,%eax
     188:	83 ec 08             	sub    $0x8,%esp
     18b:	68 a2 44 00 00       	push   $0x44a2
     190:	50                   	push   %eax
     191:	e8 a8 3e 00 00       	call   403e <printf>
     196:	83 c4 10             	add    $0x10,%esp
      exit();
     199:	e8 2d 3d 00 00       	call   3ecb <exit>
    }
    if(unlink("../iputdir") < 0){
     19e:	83 ec 0c             	sub    $0xc,%esp
     1a1:	68 41 44 00 00       	push   $0x4441
     1a6:	e8 70 3d 00 00       	call   3f1b <unlink>
     1ab:	83 c4 10             	add    $0x10,%esp
     1ae:	85 c0                	test   %eax,%eax
     1b0:	79 1b                	jns    1cd <exitiputtest+0xdc>
      printf(stdout, "unlink ../iputdir failed\n");
     1b2:	a1 a8 62 00 00       	mov    0x62a8,%eax
     1b7:	83 ec 08             	sub    $0x8,%esp
     1ba:	68 4c 44 00 00       	push   $0x444c
     1bf:	50                   	push   %eax
     1c0:	e8 79 3e 00 00       	call   403e <printf>
     1c5:	83 c4 10             	add    $0x10,%esp
      exit();
     1c8:	e8 fe 3c 00 00       	call   3ecb <exit>
    }
    exit();
     1cd:	e8 f9 3c 00 00       	call   3ecb <exit>
  }
  wait();
     1d2:	e8 fc 3c 00 00       	call   3ed3 <wait>
  printf(stdout, "exitiput test ok\n");
     1d7:	a1 a8 62 00 00       	mov    0x62a8,%eax
     1dc:	83 ec 08             	sub    $0x8,%esp
     1df:	68 b6 44 00 00       	push   $0x44b6
     1e4:	50                   	push   %eax
     1e5:	e8 54 3e 00 00       	call   403e <printf>
     1ea:	83 c4 10             	add    $0x10,%esp
}
     1ed:	90                   	nop
     1ee:	c9                   	leave  
     1ef:	c3                   	ret    

000001f0 <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1f0:	55                   	push   %ebp
     1f1:	89 e5                	mov    %esp,%ebp
     1f3:	83 ec 18             	sub    $0x18,%esp
  int pid;

  printf(stdout, "openiput test\n");
     1f6:	a1 a8 62 00 00       	mov    0x62a8,%eax
     1fb:	83 ec 08             	sub    $0x8,%esp
     1fe:	68 c8 44 00 00       	push   $0x44c8
     203:	50                   	push   %eax
     204:	e8 35 3e 00 00       	call   403e <printf>
     209:	83 c4 10             	add    $0x10,%esp
  if(mkdir("oidir") < 0){
     20c:	83 ec 0c             	sub    $0xc,%esp
     20f:	68 d7 44 00 00       	push   $0x44d7
     214:	e8 1a 3d 00 00       	call   3f33 <mkdir>
     219:	83 c4 10             	add    $0x10,%esp
     21c:	85 c0                	test   %eax,%eax
     21e:	79 1b                	jns    23b <openiputtest+0x4b>
    printf(stdout, "mkdir oidir failed\n");
     220:	a1 a8 62 00 00       	mov    0x62a8,%eax
     225:	83 ec 08             	sub    $0x8,%esp
     228:	68 dd 44 00 00       	push   $0x44dd
     22d:	50                   	push   %eax
     22e:	e8 0b 3e 00 00       	call   403e <printf>
     233:	83 c4 10             	add    $0x10,%esp
    exit();
     236:	e8 90 3c 00 00       	call   3ecb <exit>
  }
  pid = fork();
     23b:	e8 83 3c 00 00       	call   3ec3 <fork>
     240:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
     243:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     247:	79 1b                	jns    264 <openiputtest+0x74>
    printf(stdout, "fork failed\n");
     249:	a1 a8 62 00 00       	mov    0x62a8,%eax
     24e:	83 ec 08             	sub    $0x8,%esp
     251:	68 95 44 00 00       	push   $0x4495
     256:	50                   	push   %eax
     257:	e8 e2 3d 00 00       	call   403e <printf>
     25c:	83 c4 10             	add    $0x10,%esp
    exit();
     25f:	e8 67 3c 00 00       	call   3ecb <exit>
  }
  if(pid == 0){
     264:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     268:	75 3b                	jne    2a5 <openiputtest+0xb5>
    int fd = open("oidir", O_RDWR);
     26a:	83 ec 08             	sub    $0x8,%esp
     26d:	6a 02                	push   $0x2
     26f:	68 d7 44 00 00       	push   $0x44d7
     274:	e8 92 3c 00 00       	call   3f0b <open>
     279:	83 c4 10             	add    $0x10,%esp
     27c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0){
     27f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     283:	78 1b                	js     2a0 <openiputtest+0xb0>
      printf(stdout, "open directory for write succeeded\n");
     285:	a1 a8 62 00 00       	mov    0x62a8,%eax
     28a:	83 ec 08             	sub    $0x8,%esp
     28d:	68 f4 44 00 00       	push   $0x44f4
     292:	50                   	push   %eax
     293:	e8 a6 3d 00 00       	call   403e <printf>
     298:	83 c4 10             	add    $0x10,%esp
      exit();
     29b:	e8 2b 3c 00 00       	call   3ecb <exit>
    }
    exit();
     2a0:	e8 26 3c 00 00       	call   3ecb <exit>
  }
  sleep(1);
     2a5:	83 ec 0c             	sub    $0xc,%esp
     2a8:	6a 01                	push   $0x1
     2aa:	e8 ac 3c 00 00       	call   3f5b <sleep>
     2af:	83 c4 10             	add    $0x10,%esp
  if(unlink("oidir") != 0){
     2b2:	83 ec 0c             	sub    $0xc,%esp
     2b5:	68 d7 44 00 00       	push   $0x44d7
     2ba:	e8 5c 3c 00 00       	call   3f1b <unlink>
     2bf:	83 c4 10             	add    $0x10,%esp
     2c2:	85 c0                	test   %eax,%eax
     2c4:	74 1b                	je     2e1 <openiputtest+0xf1>
    printf(stdout, "unlink failed\n");
     2c6:	a1 a8 62 00 00       	mov    0x62a8,%eax
     2cb:	83 ec 08             	sub    $0x8,%esp
     2ce:	68 18 45 00 00       	push   $0x4518
     2d3:	50                   	push   %eax
     2d4:	e8 65 3d 00 00       	call   403e <printf>
     2d9:	83 c4 10             	add    $0x10,%esp
    exit();
     2dc:	e8 ea 3b 00 00       	call   3ecb <exit>
  }
  wait();
     2e1:	e8 ed 3b 00 00       	call   3ed3 <wait>
  printf(stdout, "openiput test ok\n");
     2e6:	a1 a8 62 00 00       	mov    0x62a8,%eax
     2eb:	83 ec 08             	sub    $0x8,%esp
     2ee:	68 27 45 00 00       	push   $0x4527
     2f3:	50                   	push   %eax
     2f4:	e8 45 3d 00 00       	call   403e <printf>
     2f9:	83 c4 10             	add    $0x10,%esp
}
     2fc:	90                   	nop
     2fd:	c9                   	leave  
     2fe:	c3                   	ret    

000002ff <opentest>:

// simple file system tests

void
opentest(void)
{
     2ff:	55                   	push   %ebp
     300:	89 e5                	mov    %esp,%ebp
     302:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(stdout, "open test\n");
     305:	a1 a8 62 00 00       	mov    0x62a8,%eax
     30a:	83 ec 08             	sub    $0x8,%esp
     30d:	68 39 45 00 00       	push   $0x4539
     312:	50                   	push   %eax
     313:	e8 26 3d 00 00       	call   403e <printf>
     318:	83 c4 10             	add    $0x10,%esp
  fd = open("echo", 0);
     31b:	83 ec 08             	sub    $0x8,%esp
     31e:	6a 00                	push   $0x0
     320:	68 f4 43 00 00       	push   $0x43f4
     325:	e8 e1 3b 00 00       	call   3f0b <open>
     32a:	83 c4 10             	add    $0x10,%esp
     32d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
     330:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     334:	79 1b                	jns    351 <opentest+0x52>
    printf(stdout, "open echo failed!\n");
     336:	a1 a8 62 00 00       	mov    0x62a8,%eax
     33b:	83 ec 08             	sub    $0x8,%esp
     33e:	68 44 45 00 00       	push   $0x4544
     343:	50                   	push   %eax
     344:	e8 f5 3c 00 00       	call   403e <printf>
     349:	83 c4 10             	add    $0x10,%esp
    exit();
     34c:	e8 7a 3b 00 00       	call   3ecb <exit>
  }
  close(fd);
     351:	83 ec 0c             	sub    $0xc,%esp
     354:	ff 75 f4             	pushl  -0xc(%ebp)
     357:	e8 97 3b 00 00       	call   3ef3 <close>
     35c:	83 c4 10             	add    $0x10,%esp
  fd = open("doesnotexist", 0);
     35f:	83 ec 08             	sub    $0x8,%esp
     362:	6a 00                	push   $0x0
     364:	68 57 45 00 00       	push   $0x4557
     369:	e8 9d 3b 00 00       	call   3f0b <open>
     36e:	83 c4 10             	add    $0x10,%esp
     371:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
     374:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     378:	78 1b                	js     395 <opentest+0x96>
    printf(stdout, "open doesnotexist succeeded!\n");
     37a:	a1 a8 62 00 00       	mov    0x62a8,%eax
     37f:	83 ec 08             	sub    $0x8,%esp
     382:	68 64 45 00 00       	push   $0x4564
     387:	50                   	push   %eax
     388:	e8 b1 3c 00 00       	call   403e <printf>
     38d:	83 c4 10             	add    $0x10,%esp
    exit();
     390:	e8 36 3b 00 00       	call   3ecb <exit>
  }
  printf(stdout, "open test ok\n");
     395:	a1 a8 62 00 00       	mov    0x62a8,%eax
     39a:	83 ec 08             	sub    $0x8,%esp
     39d:	68 82 45 00 00       	push   $0x4582
     3a2:	50                   	push   %eax
     3a3:	e8 96 3c 00 00       	call   403e <printf>
     3a8:	83 c4 10             	add    $0x10,%esp
}
     3ab:	90                   	nop
     3ac:	c9                   	leave  
     3ad:	c3                   	ret    

000003ae <writetest>:

void
writetest(void)
{
     3ae:	55                   	push   %ebp
     3af:	89 e5                	mov    %esp,%ebp
     3b1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
     3b4:	a1 a8 62 00 00       	mov    0x62a8,%eax
     3b9:	83 ec 08             	sub    $0x8,%esp
     3bc:	68 90 45 00 00       	push   $0x4590
     3c1:	50                   	push   %eax
     3c2:	e8 77 3c 00 00       	call   403e <printf>
     3c7:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_CREATE|O_RDWR);
     3ca:	83 ec 08             	sub    $0x8,%esp
     3cd:	68 02 02 00 00       	push   $0x202
     3d2:	68 a1 45 00 00       	push   $0x45a1
     3d7:	e8 2f 3b 00 00       	call   3f0b <open>
     3dc:	83 c4 10             	add    $0x10,%esp
     3df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     3e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     3e6:	78 22                	js     40a <writetest+0x5c>
    printf(stdout, "creat small succeeded; ok\n");
     3e8:	a1 a8 62 00 00       	mov    0x62a8,%eax
     3ed:	83 ec 08             	sub    $0x8,%esp
     3f0:	68 a7 45 00 00       	push   $0x45a7
     3f5:	50                   	push   %eax
     3f6:	e8 43 3c 00 00       	call   403e <printf>
     3fb:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     3fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     405:	e9 8f 00 00 00       	jmp    499 <writetest+0xeb>
    printf(stdout, "error: creat small failed!\n");
     40a:	a1 a8 62 00 00       	mov    0x62a8,%eax
     40f:	83 ec 08             	sub    $0x8,%esp
     412:	68 c2 45 00 00       	push   $0x45c2
     417:	50                   	push   %eax
     418:	e8 21 3c 00 00       	call   403e <printf>
     41d:	83 c4 10             	add    $0x10,%esp
    exit();
     420:	e8 a6 3a 00 00       	call   3ecb <exit>
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     425:	83 ec 04             	sub    $0x4,%esp
     428:	6a 0a                	push   $0xa
     42a:	68 de 45 00 00       	push   $0x45de
     42f:	ff 75 f0             	pushl  -0x10(%ebp)
     432:	e8 b4 3a 00 00       	call   3eeb <write>
     437:	83 c4 10             	add    $0x10,%esp
     43a:	83 f8 0a             	cmp    $0xa,%eax
     43d:	74 1e                	je     45d <writetest+0xaf>
      printf(stdout, "error: write aa %d new file failed\n", i);
     43f:	a1 a8 62 00 00       	mov    0x62a8,%eax
     444:	83 ec 04             	sub    $0x4,%esp
     447:	ff 75 f4             	pushl  -0xc(%ebp)
     44a:	68 ec 45 00 00       	push   $0x45ec
     44f:	50                   	push   %eax
     450:	e8 e9 3b 00 00       	call   403e <printf>
     455:	83 c4 10             	add    $0x10,%esp
      exit();
     458:	e8 6e 3a 00 00       	call   3ecb <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     45d:	83 ec 04             	sub    $0x4,%esp
     460:	6a 0a                	push   $0xa
     462:	68 10 46 00 00       	push   $0x4610
     467:	ff 75 f0             	pushl  -0x10(%ebp)
     46a:	e8 7c 3a 00 00       	call   3eeb <write>
     46f:	83 c4 10             	add    $0x10,%esp
     472:	83 f8 0a             	cmp    $0xa,%eax
     475:	74 1e                	je     495 <writetest+0xe7>
      printf(stdout, "error: write bb %d new file failed\n", i);
     477:	a1 a8 62 00 00       	mov    0x62a8,%eax
     47c:	83 ec 04             	sub    $0x4,%esp
     47f:	ff 75 f4             	pushl  -0xc(%ebp)
     482:	68 1c 46 00 00       	push   $0x461c
     487:	50                   	push   %eax
     488:	e8 b1 3b 00 00       	call   403e <printf>
     48d:	83 c4 10             	add    $0x10,%esp
      exit();
     490:	e8 36 3a 00 00       	call   3ecb <exit>
  for(i = 0; i < 100; i++){
     495:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     499:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     49d:	7e 86                	jle    425 <writetest+0x77>
    }
  }
  printf(stdout, "writes ok\n");
     49f:	a1 a8 62 00 00       	mov    0x62a8,%eax
     4a4:	83 ec 08             	sub    $0x8,%esp
     4a7:	68 40 46 00 00       	push   $0x4640
     4ac:	50                   	push   %eax
     4ad:	e8 8c 3b 00 00       	call   403e <printf>
     4b2:	83 c4 10             	add    $0x10,%esp
  close(fd);
     4b5:	83 ec 0c             	sub    $0xc,%esp
     4b8:	ff 75 f0             	pushl  -0x10(%ebp)
     4bb:	e8 33 3a 00 00       	call   3ef3 <close>
     4c0:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_RDONLY);
     4c3:	83 ec 08             	sub    $0x8,%esp
     4c6:	6a 00                	push   $0x0
     4c8:	68 a1 45 00 00       	push   $0x45a1
     4cd:	e8 39 3a 00 00       	call   3f0b <open>
     4d2:	83 c4 10             	add    $0x10,%esp
     4d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     4d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     4dc:	78 3c                	js     51a <writetest+0x16c>
    printf(stdout, "open small succeeded ok\n");
     4de:	a1 a8 62 00 00       	mov    0x62a8,%eax
     4e3:	83 ec 08             	sub    $0x8,%esp
     4e6:	68 4b 46 00 00       	push   $0x464b
     4eb:	50                   	push   %eax
     4ec:	e8 4d 3b 00 00       	call   403e <printf>
     4f1:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     4f4:	83 ec 04             	sub    $0x4,%esp
     4f7:	68 d0 07 00 00       	push   $0x7d0
     4fc:	68 a0 8a 00 00       	push   $0x8aa0
     501:	ff 75 f0             	pushl  -0x10(%ebp)
     504:	e8 da 39 00 00       	call   3ee3 <read>
     509:	83 c4 10             	add    $0x10,%esp
     50c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(i == 2000){
     50f:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
     516:	75 57                	jne    56f <writetest+0x1c1>
     518:	eb 1b                	jmp    535 <writetest+0x187>
    printf(stdout, "error: open small failed!\n");
     51a:	a1 a8 62 00 00       	mov    0x62a8,%eax
     51f:	83 ec 08             	sub    $0x8,%esp
     522:	68 64 46 00 00       	push   $0x4664
     527:	50                   	push   %eax
     528:	e8 11 3b 00 00       	call   403e <printf>
     52d:	83 c4 10             	add    $0x10,%esp
    exit();
     530:	e8 96 39 00 00       	call   3ecb <exit>
    printf(stdout, "read succeeded ok\n");
     535:	a1 a8 62 00 00       	mov    0x62a8,%eax
     53a:	83 ec 08             	sub    $0x8,%esp
     53d:	68 7f 46 00 00       	push   $0x467f
     542:	50                   	push   %eax
     543:	e8 f6 3a 00 00       	call   403e <printf>
     548:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     54b:	83 ec 0c             	sub    $0xc,%esp
     54e:	ff 75 f0             	pushl  -0x10(%ebp)
     551:	e8 9d 39 00 00       	call   3ef3 <close>
     556:	83 c4 10             	add    $0x10,%esp

  if(unlink("small") < 0){
     559:	83 ec 0c             	sub    $0xc,%esp
     55c:	68 a1 45 00 00       	push   $0x45a1
     561:	e8 b5 39 00 00       	call   3f1b <unlink>
     566:	83 c4 10             	add    $0x10,%esp
     569:	85 c0                	test   %eax,%eax
     56b:	79 38                	jns    5a5 <writetest+0x1f7>
     56d:	eb 1b                	jmp    58a <writetest+0x1dc>
    printf(stdout, "read failed\n");
     56f:	a1 a8 62 00 00       	mov    0x62a8,%eax
     574:	83 ec 08             	sub    $0x8,%esp
     577:	68 92 46 00 00       	push   $0x4692
     57c:	50                   	push   %eax
     57d:	e8 bc 3a 00 00       	call   403e <printf>
     582:	83 c4 10             	add    $0x10,%esp
    exit();
     585:	e8 41 39 00 00       	call   3ecb <exit>
    printf(stdout, "unlink small failed\n");
     58a:	a1 a8 62 00 00       	mov    0x62a8,%eax
     58f:	83 ec 08             	sub    $0x8,%esp
     592:	68 9f 46 00 00       	push   $0x469f
     597:	50                   	push   %eax
     598:	e8 a1 3a 00 00       	call   403e <printf>
     59d:	83 c4 10             	add    $0x10,%esp
    exit();
     5a0:	e8 26 39 00 00       	call   3ecb <exit>
  }
  printf(stdout, "small file test ok\n");
     5a5:	a1 a8 62 00 00       	mov    0x62a8,%eax
     5aa:	83 ec 08             	sub    $0x8,%esp
     5ad:	68 b4 46 00 00       	push   $0x46b4
     5b2:	50                   	push   %eax
     5b3:	e8 86 3a 00 00       	call   403e <printf>
     5b8:	83 c4 10             	add    $0x10,%esp
}
     5bb:	90                   	nop
     5bc:	c9                   	leave  
     5bd:	c3                   	ret    

000005be <writetest1>:

void
writetest1(void)
{
     5be:	55                   	push   %ebp
     5bf:	89 e5                	mov    %esp,%ebp
     5c1:	83 ec 18             	sub    $0x18,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
     5c4:	a1 a8 62 00 00       	mov    0x62a8,%eax
     5c9:	83 ec 08             	sub    $0x8,%esp
     5cc:	68 c8 46 00 00       	push   $0x46c8
     5d1:	50                   	push   %eax
     5d2:	e8 67 3a 00 00       	call   403e <printf>
     5d7:	83 c4 10             	add    $0x10,%esp

  fd = open("big", O_CREATE|O_RDWR);
     5da:	83 ec 08             	sub    $0x8,%esp
     5dd:	68 02 02 00 00       	push   $0x202
     5e2:	68 d8 46 00 00       	push   $0x46d8
     5e7:	e8 1f 39 00 00       	call   3f0b <open>
     5ec:	83 c4 10             	add    $0x10,%esp
     5ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     5f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     5f6:	79 1b                	jns    613 <writetest1+0x55>
    printf(stdout, "error: creat big failed!\n");
     5f8:	a1 a8 62 00 00       	mov    0x62a8,%eax
     5fd:	83 ec 08             	sub    $0x8,%esp
     600:	68 dc 46 00 00       	push   $0x46dc
     605:	50                   	push   %eax
     606:	e8 33 3a 00 00       	call   403e <printf>
     60b:	83 c4 10             	add    $0x10,%esp
    exit();
     60e:	e8 b8 38 00 00       	call   3ecb <exit>
  }

  for(i = 0; i < MAXFILE; i++){
     613:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     61a:	eb 4b                	jmp    667 <writetest1+0xa9>
    ((int*)buf)[0] = i;
     61c:	ba a0 8a 00 00       	mov    $0x8aa0,%edx
     621:	8b 45 f4             	mov    -0xc(%ebp),%eax
     624:	89 02                	mov    %eax,(%edx)
    if(write(fd, buf, 512) != 512){
     626:	83 ec 04             	sub    $0x4,%esp
     629:	68 00 02 00 00       	push   $0x200
     62e:	68 a0 8a 00 00       	push   $0x8aa0
     633:	ff 75 ec             	pushl  -0x14(%ebp)
     636:	e8 b0 38 00 00       	call   3eeb <write>
     63b:	83 c4 10             	add    $0x10,%esp
     63e:	3d 00 02 00 00       	cmp    $0x200,%eax
     643:	74 1e                	je     663 <writetest1+0xa5>
      printf(stdout, "error: write big file failed\n", i);
     645:	a1 a8 62 00 00       	mov    0x62a8,%eax
     64a:	83 ec 04             	sub    $0x4,%esp
     64d:	ff 75 f4             	pushl  -0xc(%ebp)
     650:	68 f6 46 00 00       	push   $0x46f6
     655:	50                   	push   %eax
     656:	e8 e3 39 00 00       	call   403e <printf>
     65b:	83 c4 10             	add    $0x10,%esp
      exit();
     65e:	e8 68 38 00 00       	call   3ecb <exit>
  for(i = 0; i < MAXFILE; i++){
     663:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     667:	8b 45 f4             	mov    -0xc(%ebp),%eax
     66a:	3d 8b 00 00 00       	cmp    $0x8b,%eax
     66f:	76 ab                	jbe    61c <writetest1+0x5e>
    }
  }

  close(fd);
     671:	83 ec 0c             	sub    $0xc,%esp
     674:	ff 75 ec             	pushl  -0x14(%ebp)
     677:	e8 77 38 00 00       	call   3ef3 <close>
     67c:	83 c4 10             	add    $0x10,%esp

  fd = open("big", O_RDONLY);
     67f:	83 ec 08             	sub    $0x8,%esp
     682:	6a 00                	push   $0x0
     684:	68 d8 46 00 00       	push   $0x46d8
     689:	e8 7d 38 00 00       	call   3f0b <open>
     68e:	83 c4 10             	add    $0x10,%esp
     691:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     694:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     698:	79 1b                	jns    6b5 <writetest1+0xf7>
    printf(stdout, "error: open big failed!\n");
     69a:	a1 a8 62 00 00       	mov    0x62a8,%eax
     69f:	83 ec 08             	sub    $0x8,%esp
     6a2:	68 14 47 00 00       	push   $0x4714
     6a7:	50                   	push   %eax
     6a8:	e8 91 39 00 00       	call   403e <printf>
     6ad:	83 c4 10             	add    $0x10,%esp
    exit();
     6b0:	e8 16 38 00 00       	call   3ecb <exit>
  }

  n = 0;
     6b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    i = read(fd, buf, 512);
     6bc:	83 ec 04             	sub    $0x4,%esp
     6bf:	68 00 02 00 00       	push   $0x200
     6c4:	68 a0 8a 00 00       	push   $0x8aa0
     6c9:	ff 75 ec             	pushl  -0x14(%ebp)
     6cc:	e8 12 38 00 00       	call   3ee3 <read>
     6d1:	83 c4 10             	add    $0x10,%esp
     6d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(i == 0){
     6d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     6db:	75 27                	jne    704 <writetest1+0x146>
      if(n == MAXFILE - 1){
     6dd:	81 7d f0 8b 00 00 00 	cmpl   $0x8b,-0x10(%ebp)
     6e4:	75 7d                	jne    763 <writetest1+0x1a5>
        printf(stdout, "read only %d blocks from big", n);
     6e6:	a1 a8 62 00 00       	mov    0x62a8,%eax
     6eb:	83 ec 04             	sub    $0x4,%esp
     6ee:	ff 75 f0             	pushl  -0x10(%ebp)
     6f1:	68 2d 47 00 00       	push   $0x472d
     6f6:	50                   	push   %eax
     6f7:	e8 42 39 00 00       	call   403e <printf>
     6fc:	83 c4 10             	add    $0x10,%esp
        exit();
     6ff:	e8 c7 37 00 00       	call   3ecb <exit>
      }
      break;
    } else if(i != 512){
     704:	81 7d f4 00 02 00 00 	cmpl   $0x200,-0xc(%ebp)
     70b:	74 1e                	je     72b <writetest1+0x16d>
      printf(stdout, "read failed %d\n", i);
     70d:	a1 a8 62 00 00       	mov    0x62a8,%eax
     712:	83 ec 04             	sub    $0x4,%esp
     715:	ff 75 f4             	pushl  -0xc(%ebp)
     718:	68 4a 47 00 00       	push   $0x474a
     71d:	50                   	push   %eax
     71e:	e8 1b 39 00 00       	call   403e <printf>
     723:	83 c4 10             	add    $0x10,%esp
      exit();
     726:	e8 a0 37 00 00       	call   3ecb <exit>
    }
    if(((int*)buf)[0] != n){
     72b:	b8 a0 8a 00 00       	mov    $0x8aa0,%eax
     730:	8b 00                	mov    (%eax),%eax
     732:	39 45 f0             	cmp    %eax,-0x10(%ebp)
     735:	74 23                	je     75a <writetest1+0x19c>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
     737:	b8 a0 8a 00 00       	mov    $0x8aa0,%eax
      printf(stdout, "read content of block %d is %d\n",
     73c:	8b 10                	mov    (%eax),%edx
     73e:	a1 a8 62 00 00       	mov    0x62a8,%eax
     743:	52                   	push   %edx
     744:	ff 75 f0             	pushl  -0x10(%ebp)
     747:	68 5c 47 00 00       	push   $0x475c
     74c:	50                   	push   %eax
     74d:	e8 ec 38 00 00       	call   403e <printf>
     752:	83 c4 10             	add    $0x10,%esp
      exit();
     755:	e8 71 37 00 00       	call   3ecb <exit>
    }
    n++;
     75a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    i = read(fd, buf, 512);
     75e:	e9 59 ff ff ff       	jmp    6bc <writetest1+0xfe>
      break;
     763:	90                   	nop
  }
  close(fd);
     764:	83 ec 0c             	sub    $0xc,%esp
     767:	ff 75 ec             	pushl  -0x14(%ebp)
     76a:	e8 84 37 00 00       	call   3ef3 <close>
     76f:	83 c4 10             	add    $0x10,%esp
  if(unlink("big") < 0){
     772:	83 ec 0c             	sub    $0xc,%esp
     775:	68 d8 46 00 00       	push   $0x46d8
     77a:	e8 9c 37 00 00       	call   3f1b <unlink>
     77f:	83 c4 10             	add    $0x10,%esp
     782:	85 c0                	test   %eax,%eax
     784:	79 1b                	jns    7a1 <writetest1+0x1e3>
    printf(stdout, "unlink big failed\n");
     786:	a1 a8 62 00 00       	mov    0x62a8,%eax
     78b:	83 ec 08             	sub    $0x8,%esp
     78e:	68 7c 47 00 00       	push   $0x477c
     793:	50                   	push   %eax
     794:	e8 a5 38 00 00       	call   403e <printf>
     799:	83 c4 10             	add    $0x10,%esp
    exit();
     79c:	e8 2a 37 00 00       	call   3ecb <exit>
  }
  printf(stdout, "big files ok\n");
     7a1:	a1 a8 62 00 00       	mov    0x62a8,%eax
     7a6:	83 ec 08             	sub    $0x8,%esp
     7a9:	68 8f 47 00 00       	push   $0x478f
     7ae:	50                   	push   %eax
     7af:	e8 8a 38 00 00       	call   403e <printf>
     7b4:	83 c4 10             	add    $0x10,%esp
}
     7b7:	90                   	nop
     7b8:	c9                   	leave  
     7b9:	c3                   	ret    

000007ba <createtest>:

void
createtest(void)
{
     7ba:	55                   	push   %ebp
     7bb:	89 e5                	mov    %esp,%ebp
     7bd:	83 ec 18             	sub    $0x18,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     7c0:	a1 a8 62 00 00       	mov    0x62a8,%eax
     7c5:	83 ec 08             	sub    $0x8,%esp
     7c8:	68 a0 47 00 00       	push   $0x47a0
     7cd:	50                   	push   %eax
     7ce:	e8 6b 38 00 00       	call   403e <printf>
     7d3:	83 c4 10             	add    $0x10,%esp

  name[0] = 'a';
     7d6:	c6 05 a0 aa 00 00 61 	movb   $0x61,0xaaa0
  name[2] = '\0';
     7dd:	c6 05 a2 aa 00 00 00 	movb   $0x0,0xaaa2
  for(i = 0; i < 52; i++){
     7e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     7eb:	eb 35                	jmp    822 <createtest+0x68>
    name[1] = '0' + i;
     7ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7f0:	83 c0 30             	add    $0x30,%eax
     7f3:	a2 a1 aa 00 00       	mov    %al,0xaaa1
    fd = open(name, O_CREATE|O_RDWR);
     7f8:	83 ec 08             	sub    $0x8,%esp
     7fb:	68 02 02 00 00       	push   $0x202
     800:	68 a0 aa 00 00       	push   $0xaaa0
     805:	e8 01 37 00 00       	call   3f0b <open>
     80a:	83 c4 10             	add    $0x10,%esp
     80d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(fd);
     810:	83 ec 0c             	sub    $0xc,%esp
     813:	ff 75 f0             	pushl  -0x10(%ebp)
     816:	e8 d8 36 00 00       	call   3ef3 <close>
     81b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 52; i++){
     81e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     822:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     826:	7e c5                	jle    7ed <createtest+0x33>
  }
  name[0] = 'a';
     828:	c6 05 a0 aa 00 00 61 	movb   $0x61,0xaaa0
  name[2] = '\0';
     82f:	c6 05 a2 aa 00 00 00 	movb   $0x0,0xaaa2
  for(i = 0; i < 52; i++){
     836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     83d:	eb 1f                	jmp    85e <createtest+0xa4>
    name[1] = '0' + i;
     83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     842:	83 c0 30             	add    $0x30,%eax
     845:	a2 a1 aa 00 00       	mov    %al,0xaaa1
    unlink(name);
     84a:	83 ec 0c             	sub    $0xc,%esp
     84d:	68 a0 aa 00 00       	push   $0xaaa0
     852:	e8 c4 36 00 00       	call   3f1b <unlink>
     857:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 52; i++){
     85a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     85e:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     862:	7e db                	jle    83f <createtest+0x85>
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     864:	a1 a8 62 00 00       	mov    0x62a8,%eax
     869:	83 ec 08             	sub    $0x8,%esp
     86c:	68 c8 47 00 00       	push   $0x47c8
     871:	50                   	push   %eax
     872:	e8 c7 37 00 00       	call   403e <printf>
     877:	83 c4 10             	add    $0x10,%esp
}
     87a:	90                   	nop
     87b:	c9                   	leave  
     87c:	c3                   	ret    

0000087d <dirtest>:

void dirtest(void)
{
     87d:	55                   	push   %ebp
     87e:	89 e5                	mov    %esp,%ebp
     880:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "mkdir test\n");
     883:	a1 a8 62 00 00       	mov    0x62a8,%eax
     888:	83 ec 08             	sub    $0x8,%esp
     88b:	68 ee 47 00 00       	push   $0x47ee
     890:	50                   	push   %eax
     891:	e8 a8 37 00 00       	call   403e <printf>
     896:	83 c4 10             	add    $0x10,%esp

  if(mkdir("dir0") < 0){
     899:	83 ec 0c             	sub    $0xc,%esp
     89c:	68 fa 47 00 00       	push   $0x47fa
     8a1:	e8 8d 36 00 00       	call   3f33 <mkdir>
     8a6:	83 c4 10             	add    $0x10,%esp
     8a9:	85 c0                	test   %eax,%eax
     8ab:	79 1b                	jns    8c8 <dirtest+0x4b>
    printf(stdout, "mkdir failed\n");
     8ad:	a1 a8 62 00 00       	mov    0x62a8,%eax
     8b2:	83 ec 08             	sub    $0x8,%esp
     8b5:	68 1d 44 00 00       	push   $0x441d
     8ba:	50                   	push   %eax
     8bb:	e8 7e 37 00 00       	call   403e <printf>
     8c0:	83 c4 10             	add    $0x10,%esp
    exit();
     8c3:	e8 03 36 00 00       	call   3ecb <exit>
  }

  if(chdir("dir0") < 0){
     8c8:	83 ec 0c             	sub    $0xc,%esp
     8cb:	68 fa 47 00 00       	push   $0x47fa
     8d0:	e8 66 36 00 00       	call   3f3b <chdir>
     8d5:	83 c4 10             	add    $0x10,%esp
     8d8:	85 c0                	test   %eax,%eax
     8da:	79 1b                	jns    8f7 <dirtest+0x7a>
    printf(stdout, "chdir dir0 failed\n");
     8dc:	a1 a8 62 00 00       	mov    0x62a8,%eax
     8e1:	83 ec 08             	sub    $0x8,%esp
     8e4:	68 ff 47 00 00       	push   $0x47ff
     8e9:	50                   	push   %eax
     8ea:	e8 4f 37 00 00       	call   403e <printf>
     8ef:	83 c4 10             	add    $0x10,%esp
    exit();
     8f2:	e8 d4 35 00 00       	call   3ecb <exit>
  }

  if(chdir("..") < 0){
     8f7:	83 ec 0c             	sub    $0xc,%esp
     8fa:	68 12 48 00 00       	push   $0x4812
     8ff:	e8 37 36 00 00       	call   3f3b <chdir>
     904:	83 c4 10             	add    $0x10,%esp
     907:	85 c0                	test   %eax,%eax
     909:	79 1b                	jns    926 <dirtest+0xa9>
    printf(stdout, "chdir .. failed\n");
     90b:	a1 a8 62 00 00       	mov    0x62a8,%eax
     910:	83 ec 08             	sub    $0x8,%esp
     913:	68 15 48 00 00       	push   $0x4815
     918:	50                   	push   %eax
     919:	e8 20 37 00 00       	call   403e <printf>
     91e:	83 c4 10             	add    $0x10,%esp
    exit();
     921:	e8 a5 35 00 00       	call   3ecb <exit>
  }

  if(unlink("dir0") < 0){
     926:	83 ec 0c             	sub    $0xc,%esp
     929:	68 fa 47 00 00       	push   $0x47fa
     92e:	e8 e8 35 00 00       	call   3f1b <unlink>
     933:	83 c4 10             	add    $0x10,%esp
     936:	85 c0                	test   %eax,%eax
     938:	79 1b                	jns    955 <dirtest+0xd8>
    printf(stdout, "unlink dir0 failed\n");
     93a:	a1 a8 62 00 00       	mov    0x62a8,%eax
     93f:	83 ec 08             	sub    $0x8,%esp
     942:	68 26 48 00 00       	push   $0x4826
     947:	50                   	push   %eax
     948:	e8 f1 36 00 00       	call   403e <printf>
     94d:	83 c4 10             	add    $0x10,%esp
    exit();
     950:	e8 76 35 00 00       	call   3ecb <exit>
  }
  printf(stdout, "mkdir test ok\n");
     955:	a1 a8 62 00 00       	mov    0x62a8,%eax
     95a:	83 ec 08             	sub    $0x8,%esp
     95d:	68 3a 48 00 00       	push   $0x483a
     962:	50                   	push   %eax
     963:	e8 d6 36 00 00       	call   403e <printf>
     968:	83 c4 10             	add    $0x10,%esp
}
     96b:	90                   	nop
     96c:	c9                   	leave  
     96d:	c3                   	ret    

0000096e <exectest>:

void
exectest(void)
{
     96e:	55                   	push   %ebp
     96f:	89 e5                	mov    %esp,%ebp
     971:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "exec test\n");
     974:	a1 a8 62 00 00       	mov    0x62a8,%eax
     979:	83 ec 08             	sub    $0x8,%esp
     97c:	68 49 48 00 00       	push   $0x4849
     981:	50                   	push   %eax
     982:	e8 b7 36 00 00       	call   403e <printf>
     987:	83 c4 10             	add    $0x10,%esp
  if(exec("echo", echoargv) < 0){
     98a:	83 ec 08             	sub    $0x8,%esp
     98d:	68 94 62 00 00       	push   $0x6294
     992:	68 f4 43 00 00       	push   $0x43f4
     997:	e8 67 35 00 00       	call   3f03 <exec>
     99c:	83 c4 10             	add    $0x10,%esp
     99f:	85 c0                	test   %eax,%eax
     9a1:	79 1b                	jns    9be <exectest+0x50>
    printf(stdout, "exec echo failed\n");
     9a3:	a1 a8 62 00 00       	mov    0x62a8,%eax
     9a8:	83 ec 08             	sub    $0x8,%esp
     9ab:	68 54 48 00 00       	push   $0x4854
     9b0:	50                   	push   %eax
     9b1:	e8 88 36 00 00       	call   403e <printf>
     9b6:	83 c4 10             	add    $0x10,%esp
    exit();
     9b9:	e8 0d 35 00 00       	call   3ecb <exit>
  }
}
     9be:	90                   	nop
     9bf:	c9                   	leave  
     9c0:	c3                   	ret    

000009c1 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     9c1:	55                   	push   %ebp
     9c2:	89 e5                	mov    %esp,%ebp
     9c4:	83 ec 28             	sub    $0x28,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     9c7:	83 ec 0c             	sub    $0xc,%esp
     9ca:	8d 45 d8             	lea    -0x28(%ebp),%eax
     9cd:	50                   	push   %eax
     9ce:	e8 08 35 00 00       	call   3edb <pipe>
     9d3:	83 c4 10             	add    $0x10,%esp
     9d6:	85 c0                	test   %eax,%eax
     9d8:	74 17                	je     9f1 <pipe1+0x30>
    printf(1, "pipe() failed\n");
     9da:	83 ec 08             	sub    $0x8,%esp
     9dd:	68 66 48 00 00       	push   $0x4866
     9e2:	6a 01                	push   $0x1
     9e4:	e8 55 36 00 00       	call   403e <printf>
     9e9:	83 c4 10             	add    $0x10,%esp
    exit();
     9ec:	e8 da 34 00 00       	call   3ecb <exit>
  }
  pid = fork();
     9f1:	e8 cd 34 00 00       	call   3ec3 <fork>
     9f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  seq = 0;
     9f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(pid == 0){
     a00:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     a04:	0f 85 89 00 00 00    	jne    a93 <pipe1+0xd2>
    close(fds[0]);
     a0a:	8b 45 d8             	mov    -0x28(%ebp),%eax
     a0d:	83 ec 0c             	sub    $0xc,%esp
     a10:	50                   	push   %eax
     a11:	e8 dd 34 00 00       	call   3ef3 <close>
     a16:	83 c4 10             	add    $0x10,%esp
    for(n = 0; n < 5; n++){
     a19:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     a20:	eb 66                	jmp    a88 <pipe1+0xc7>
      for(i = 0; i < 1033; i++)
     a22:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     a29:	eb 19                	jmp    a44 <pipe1+0x83>
        buf[i] = seq++;
     a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a2e:	8d 50 01             	lea    0x1(%eax),%edx
     a31:	89 55 f4             	mov    %edx,-0xc(%ebp)
     a34:	89 c2                	mov    %eax,%edx
     a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a39:	05 a0 8a 00 00       	add    $0x8aa0,%eax
     a3e:	88 10                	mov    %dl,(%eax)
      for(i = 0; i < 1033; i++)
     a40:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     a44:	81 7d f0 08 04 00 00 	cmpl   $0x408,-0x10(%ebp)
     a4b:	7e de                	jle    a2b <pipe1+0x6a>
      if(write(fds[1], buf, 1033) != 1033){
     a4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
     a50:	83 ec 04             	sub    $0x4,%esp
     a53:	68 09 04 00 00       	push   $0x409
     a58:	68 a0 8a 00 00       	push   $0x8aa0
     a5d:	50                   	push   %eax
     a5e:	e8 88 34 00 00       	call   3eeb <write>
     a63:	83 c4 10             	add    $0x10,%esp
     a66:	3d 09 04 00 00       	cmp    $0x409,%eax
     a6b:	74 17                	je     a84 <pipe1+0xc3>
        printf(1, "pipe1 oops 1\n");
     a6d:	83 ec 08             	sub    $0x8,%esp
     a70:	68 75 48 00 00       	push   $0x4875
     a75:	6a 01                	push   $0x1
     a77:	e8 c2 35 00 00       	call   403e <printf>
     a7c:	83 c4 10             	add    $0x10,%esp
        exit();
     a7f:	e8 47 34 00 00       	call   3ecb <exit>
    for(n = 0; n < 5; n++){
     a84:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     a88:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
     a8c:	7e 94                	jle    a22 <pipe1+0x61>
      }
    }
    exit();
     a8e:	e8 38 34 00 00       	call   3ecb <exit>
  } else if(pid > 0){
     a93:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     a97:	0f 8e f4 00 00 00    	jle    b91 <pipe1+0x1d0>
    close(fds[1]);
     a9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
     aa0:	83 ec 0c             	sub    $0xc,%esp
     aa3:	50                   	push   %eax
     aa4:	e8 4a 34 00 00       	call   3ef3 <close>
     aa9:	83 c4 10             	add    $0x10,%esp
    total = 0;
     aac:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    cc = 1;
     ab3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     aba:	eb 66                	jmp    b22 <pipe1+0x161>
      for(i = 0; i < n; i++){
     abc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     ac3:	eb 3b                	jmp    b00 <pipe1+0x13f>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ac8:	05 a0 8a 00 00       	add    $0x8aa0,%eax
     acd:	0f b6 00             	movzbl (%eax),%eax
     ad0:	0f be c8             	movsbl %al,%ecx
     ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ad6:	8d 50 01             	lea    0x1(%eax),%edx
     ad9:	89 55 f4             	mov    %edx,-0xc(%ebp)
     adc:	31 c8                	xor    %ecx,%eax
     ade:	0f b6 c0             	movzbl %al,%eax
     ae1:	85 c0                	test   %eax,%eax
     ae3:	74 17                	je     afc <pipe1+0x13b>
          printf(1, "pipe1 oops 2\n");
     ae5:	83 ec 08             	sub    $0x8,%esp
     ae8:	68 83 48 00 00       	push   $0x4883
     aed:	6a 01                	push   $0x1
     aef:	e8 4a 35 00 00       	call   403e <printf>
     af4:	83 c4 10             	add    $0x10,%esp
     af7:	e9 ac 00 00 00       	jmp    ba8 <pipe1+0x1e7>
      for(i = 0; i < n; i++){
     afc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b03:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     b06:	7c bd                	jl     ac5 <pipe1+0x104>
          return;
        }
      }
      total += n;
     b08:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b0b:	01 45 e4             	add    %eax,-0x1c(%ebp)
      cc = cc * 2;
     b0e:	d1 65 e8             	shll   -0x18(%ebp)
      if(cc > sizeof(buf))
     b11:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b14:	3d 00 20 00 00       	cmp    $0x2000,%eax
     b19:	76 07                	jbe    b22 <pipe1+0x161>
        cc = sizeof(buf);
     b1b:	c7 45 e8 00 20 00 00 	movl   $0x2000,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     b22:	8b 45 d8             	mov    -0x28(%ebp),%eax
     b25:	83 ec 04             	sub    $0x4,%esp
     b28:	ff 75 e8             	pushl  -0x18(%ebp)
     b2b:	68 a0 8a 00 00       	push   $0x8aa0
     b30:	50                   	push   %eax
     b31:	e8 ad 33 00 00       	call   3ee3 <read>
     b36:	83 c4 10             	add    $0x10,%esp
     b39:	89 45 ec             	mov    %eax,-0x14(%ebp)
     b3c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     b40:	0f 8f 76 ff ff ff    	jg     abc <pipe1+0xfb>
    }
    if(total != 5 * 1033){
     b46:	81 7d e4 2d 14 00 00 	cmpl   $0x142d,-0x1c(%ebp)
     b4d:	74 1a                	je     b69 <pipe1+0x1a8>
      printf(1, "pipe1 oops 3 total %d\n", total);
     b4f:	83 ec 04             	sub    $0x4,%esp
     b52:	ff 75 e4             	pushl  -0x1c(%ebp)
     b55:	68 91 48 00 00       	push   $0x4891
     b5a:	6a 01                	push   $0x1
     b5c:	e8 dd 34 00 00       	call   403e <printf>
     b61:	83 c4 10             	add    $0x10,%esp
      exit();
     b64:	e8 62 33 00 00       	call   3ecb <exit>
    }
    close(fds[0]);
     b69:	8b 45 d8             	mov    -0x28(%ebp),%eax
     b6c:	83 ec 0c             	sub    $0xc,%esp
     b6f:	50                   	push   %eax
     b70:	e8 7e 33 00 00       	call   3ef3 <close>
     b75:	83 c4 10             	add    $0x10,%esp
    wait();
     b78:	e8 56 33 00 00       	call   3ed3 <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
     b7d:	83 ec 08             	sub    $0x8,%esp
     b80:	68 b7 48 00 00       	push   $0x48b7
     b85:	6a 01                	push   $0x1
     b87:	e8 b2 34 00 00       	call   403e <printf>
     b8c:	83 c4 10             	add    $0x10,%esp
     b8f:	eb 17                	jmp    ba8 <pipe1+0x1e7>
    printf(1, "fork() failed\n");
     b91:	83 ec 08             	sub    $0x8,%esp
     b94:	68 a8 48 00 00       	push   $0x48a8
     b99:	6a 01                	push   $0x1
     b9b:	e8 9e 34 00 00       	call   403e <printf>
     ba0:	83 c4 10             	add    $0x10,%esp
    exit();
     ba3:	e8 23 33 00 00       	call   3ecb <exit>
}
     ba8:	c9                   	leave  
     ba9:	c3                   	ret    

00000baa <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     baa:	55                   	push   %ebp
     bab:	89 e5                	mov    %esp,%ebp
     bad:	83 ec 28             	sub    $0x28,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     bb0:	83 ec 08             	sub    $0x8,%esp
     bb3:	68 c1 48 00 00       	push   $0x48c1
     bb8:	6a 01                	push   $0x1
     bba:	e8 7f 34 00 00       	call   403e <printf>
     bbf:	83 c4 10             	add    $0x10,%esp
  pid1 = fork();
     bc2:	e8 fc 32 00 00       	call   3ec3 <fork>
     bc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid1 == 0)
     bca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     bce:	75 02                	jne    bd2 <preempt+0x28>
    for(;;)
     bd0:	eb fe                	jmp    bd0 <preempt+0x26>
      ;

  pid2 = fork();
     bd2:	e8 ec 32 00 00       	call   3ec3 <fork>
     bd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid2 == 0)
     bda:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     bde:	75 02                	jne    be2 <preempt+0x38>
    for(;;)
     be0:	eb fe                	jmp    be0 <preempt+0x36>
      ;

  pipe(pfds);
     be2:	83 ec 0c             	sub    $0xc,%esp
     be5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     be8:	50                   	push   %eax
     be9:	e8 ed 32 00 00       	call   3edb <pipe>
     bee:	83 c4 10             	add    $0x10,%esp
  pid3 = fork();
     bf1:	e8 cd 32 00 00       	call   3ec3 <fork>
     bf6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid3 == 0){
     bf9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     bfd:	75 4d                	jne    c4c <preempt+0xa2>
    close(pfds[0]);
     bff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c02:	83 ec 0c             	sub    $0xc,%esp
     c05:	50                   	push   %eax
     c06:	e8 e8 32 00 00       	call   3ef3 <close>
     c0b:	83 c4 10             	add    $0x10,%esp
    if(write(pfds[1], "x", 1) != 1)
     c0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c11:	83 ec 04             	sub    $0x4,%esp
     c14:	6a 01                	push   $0x1
     c16:	68 cb 48 00 00       	push   $0x48cb
     c1b:	50                   	push   %eax
     c1c:	e8 ca 32 00 00       	call   3eeb <write>
     c21:	83 c4 10             	add    $0x10,%esp
     c24:	83 f8 01             	cmp    $0x1,%eax
     c27:	74 12                	je     c3b <preempt+0x91>
      printf(1, "preempt write error");
     c29:	83 ec 08             	sub    $0x8,%esp
     c2c:	68 cd 48 00 00       	push   $0x48cd
     c31:	6a 01                	push   $0x1
     c33:	e8 06 34 00 00       	call   403e <printf>
     c38:	83 c4 10             	add    $0x10,%esp
    close(pfds[1]);
     c3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c3e:	83 ec 0c             	sub    $0xc,%esp
     c41:	50                   	push   %eax
     c42:	e8 ac 32 00 00       	call   3ef3 <close>
     c47:	83 c4 10             	add    $0x10,%esp
    for(;;)
     c4a:	eb fe                	jmp    c4a <preempt+0xa0>
      ;
  }

  close(pfds[1]);
     c4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c4f:	83 ec 0c             	sub    $0xc,%esp
     c52:	50                   	push   %eax
     c53:	e8 9b 32 00 00       	call   3ef3 <close>
     c58:	83 c4 10             	add    $0x10,%esp
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     c5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c5e:	83 ec 04             	sub    $0x4,%esp
     c61:	68 00 20 00 00       	push   $0x2000
     c66:	68 a0 8a 00 00       	push   $0x8aa0
     c6b:	50                   	push   %eax
     c6c:	e8 72 32 00 00       	call   3ee3 <read>
     c71:	83 c4 10             	add    $0x10,%esp
     c74:	83 f8 01             	cmp    $0x1,%eax
     c77:	74 14                	je     c8d <preempt+0xe3>
    printf(1, "preempt read error");
     c79:	83 ec 08             	sub    $0x8,%esp
     c7c:	68 e1 48 00 00       	push   $0x48e1
     c81:	6a 01                	push   $0x1
     c83:	e8 b6 33 00 00       	call   403e <printf>
     c88:	83 c4 10             	add    $0x10,%esp
     c8b:	eb 7e                	jmp    d0b <preempt+0x161>
    return;
  }
  close(pfds[0]);
     c8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c90:	83 ec 0c             	sub    $0xc,%esp
     c93:	50                   	push   %eax
     c94:	e8 5a 32 00 00       	call   3ef3 <close>
     c99:	83 c4 10             	add    $0x10,%esp
  printf(1, "kill... ");
     c9c:	83 ec 08             	sub    $0x8,%esp
     c9f:	68 f4 48 00 00       	push   $0x48f4
     ca4:	6a 01                	push   $0x1
     ca6:	e8 93 33 00 00       	call   403e <printf>
     cab:	83 c4 10             	add    $0x10,%esp
  kill(pid1);
     cae:	83 ec 0c             	sub    $0xc,%esp
     cb1:	ff 75 f4             	pushl  -0xc(%ebp)
     cb4:	e8 42 32 00 00       	call   3efb <kill>
     cb9:	83 c4 10             	add    $0x10,%esp
  kill(pid2);
     cbc:	83 ec 0c             	sub    $0xc,%esp
     cbf:	ff 75 f0             	pushl  -0x10(%ebp)
     cc2:	e8 34 32 00 00       	call   3efb <kill>
     cc7:	83 c4 10             	add    $0x10,%esp
  kill(pid3);
     cca:	83 ec 0c             	sub    $0xc,%esp
     ccd:	ff 75 ec             	pushl  -0x14(%ebp)
     cd0:	e8 26 32 00 00       	call   3efb <kill>
     cd5:	83 c4 10             	add    $0x10,%esp
  printf(1, "wait... ");
     cd8:	83 ec 08             	sub    $0x8,%esp
     cdb:	68 fd 48 00 00       	push   $0x48fd
     ce0:	6a 01                	push   $0x1
     ce2:	e8 57 33 00 00       	call   403e <printf>
     ce7:	83 c4 10             	add    $0x10,%esp
  wait();
     cea:	e8 e4 31 00 00       	call   3ed3 <wait>
  wait();
     cef:	e8 df 31 00 00       	call   3ed3 <wait>
  wait();
     cf4:	e8 da 31 00 00       	call   3ed3 <wait>
  printf(1, "preempt ok\n");
     cf9:	83 ec 08             	sub    $0x8,%esp
     cfc:	68 06 49 00 00       	push   $0x4906
     d01:	6a 01                	push   $0x1
     d03:	e8 36 33 00 00       	call   403e <printf>
     d08:	83 c4 10             	add    $0x10,%esp
}
     d0b:	c9                   	leave  
     d0c:	c3                   	ret    

00000d0d <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     d0d:	55                   	push   %ebp
     d0e:	89 e5                	mov    %esp,%ebp
     d10:	83 ec 18             	sub    $0x18,%esp
  int i, pid;

  for(i = 0; i < 100; i++){
     d13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     d1a:	eb 4f                	jmp    d6b <exitwait+0x5e>
    pid = fork();
     d1c:	e8 a2 31 00 00       	call   3ec3 <fork>
     d21:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0){
     d24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d28:	79 14                	jns    d3e <exitwait+0x31>
      printf(1, "fork failed\n");
     d2a:	83 ec 08             	sub    $0x8,%esp
     d2d:	68 95 44 00 00       	push   $0x4495
     d32:	6a 01                	push   $0x1
     d34:	e8 05 33 00 00       	call   403e <printf>
     d39:	83 c4 10             	add    $0x10,%esp
      return;
     d3c:	eb 45                	jmp    d83 <exitwait+0x76>
    }
    if(pid){
     d3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d42:	74 1e                	je     d62 <exitwait+0x55>
      if(wait() != pid){
     d44:	e8 8a 31 00 00       	call   3ed3 <wait>
     d49:	39 45 f0             	cmp    %eax,-0x10(%ebp)
     d4c:	74 19                	je     d67 <exitwait+0x5a>
        printf(1, "wait wrong pid\n");
     d4e:	83 ec 08             	sub    $0x8,%esp
     d51:	68 12 49 00 00       	push   $0x4912
     d56:	6a 01                	push   $0x1
     d58:	e8 e1 32 00 00       	call   403e <printf>
     d5d:	83 c4 10             	add    $0x10,%esp
        return;
     d60:	eb 21                	jmp    d83 <exitwait+0x76>
      }
    } else {
      exit();
     d62:	e8 64 31 00 00       	call   3ecb <exit>
  for(i = 0; i < 100; i++){
     d67:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     d6b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     d6f:	7e ab                	jle    d1c <exitwait+0xf>
    }
  }
  printf(1, "exitwait ok\n");
     d71:	83 ec 08             	sub    $0x8,%esp
     d74:	68 22 49 00 00       	push   $0x4922
     d79:	6a 01                	push   $0x1
     d7b:	e8 be 32 00 00       	call   403e <printf>
     d80:	83 c4 10             	add    $0x10,%esp
}
     d83:	c9                   	leave  
     d84:	c3                   	ret    

00000d85 <mem>:

void
mem(void)
{
     d85:	55                   	push   %ebp
     d86:	89 e5                	mov    %esp,%ebp
     d88:	83 ec 18             	sub    $0x18,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     d8b:	83 ec 08             	sub    $0x8,%esp
     d8e:	68 2f 49 00 00       	push   $0x492f
     d93:	6a 01                	push   $0x1
     d95:	e8 a4 32 00 00       	call   403e <printf>
     d9a:	83 c4 10             	add    $0x10,%esp
  ppid = getpid();
     d9d:	e8 a9 31 00 00       	call   3f4b <getpid>
     da2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((pid = fork()) == 0){
     da5:	e8 19 31 00 00       	call   3ec3 <fork>
     daa:	89 45 ec             	mov    %eax,-0x14(%ebp)
     dad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     db1:	0f 85 b7 00 00 00    	jne    e6e <mem+0xe9>
    m1 = 0;
     db7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
     dbe:	eb 0e                	jmp    dce <mem+0x49>
      *(char**)m2 = m1;
     dc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
     dc6:	89 10                	mov    %edx,(%eax)
      m1 = m2;
     dc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
     dce:	83 ec 0c             	sub    $0xc,%esp
     dd1:	68 11 27 00 00       	push   $0x2711
     dd6:	e8 36 35 00 00       	call   4311 <malloc>
     ddb:	83 c4 10             	add    $0x10,%esp
     dde:	89 45 e8             	mov    %eax,-0x18(%ebp)
     de1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     de5:	75 d9                	jne    dc0 <mem+0x3b>
    }
    while(m1){
     de7:	eb 1c                	jmp    e05 <mem+0x80>
      m2 = *(char**)m1;
     de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dec:	8b 00                	mov    (%eax),%eax
     dee:	89 45 e8             	mov    %eax,-0x18(%ebp)
      free(m1);
     df1:	83 ec 0c             	sub    $0xc,%esp
     df4:	ff 75 f4             	pushl  -0xc(%ebp)
     df7:	e8 d3 33 00 00       	call   41cf <free>
     dfc:	83 c4 10             	add    $0x10,%esp
      m1 = m2;
     dff:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e02:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while(m1){
     e05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e09:	75 de                	jne    de9 <mem+0x64>
    }
    m1 = malloc(1024*20);
     e0b:	83 ec 0c             	sub    $0xc,%esp
     e0e:	68 00 50 00 00       	push   $0x5000
     e13:	e8 f9 34 00 00       	call   4311 <malloc>
     e18:	83 c4 10             	add    $0x10,%esp
     e1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(m1 == 0){
     e1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e22:	75 25                	jne    e49 <mem+0xc4>
      printf(1, "couldn't allocate mem?!!\n");
     e24:	83 ec 08             	sub    $0x8,%esp
     e27:	68 39 49 00 00       	push   $0x4939
     e2c:	6a 01                	push   $0x1
     e2e:	e8 0b 32 00 00       	call   403e <printf>
     e33:	83 c4 10             	add    $0x10,%esp
      kill(ppid);
     e36:	83 ec 0c             	sub    $0xc,%esp
     e39:	ff 75 f0             	pushl  -0x10(%ebp)
     e3c:	e8 ba 30 00 00       	call   3efb <kill>
     e41:	83 c4 10             	add    $0x10,%esp
      exit();
     e44:	e8 82 30 00 00       	call   3ecb <exit>
    }
    free(m1);
     e49:	83 ec 0c             	sub    $0xc,%esp
     e4c:	ff 75 f4             	pushl  -0xc(%ebp)
     e4f:	e8 7b 33 00 00       	call   41cf <free>
     e54:	83 c4 10             	add    $0x10,%esp
    printf(1, "mem ok\n");
     e57:	83 ec 08             	sub    $0x8,%esp
     e5a:	68 53 49 00 00       	push   $0x4953
     e5f:	6a 01                	push   $0x1
     e61:	e8 d8 31 00 00       	call   403e <printf>
     e66:	83 c4 10             	add    $0x10,%esp
    exit();
     e69:	e8 5d 30 00 00       	call   3ecb <exit>
  } else {
    wait();
     e6e:	e8 60 30 00 00       	call   3ed3 <wait>
  }
}
     e73:	90                   	nop
     e74:	c9                   	leave  
     e75:	c3                   	ret    

00000e76 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     e76:	55                   	push   %ebp
     e77:	89 e5                	mov    %esp,%ebp
     e79:	83 ec 38             	sub    $0x38,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     e7c:	83 ec 08             	sub    $0x8,%esp
     e7f:	68 5b 49 00 00       	push   $0x495b
     e84:	6a 01                	push   $0x1
     e86:	e8 b3 31 00 00       	call   403e <printf>
     e8b:	83 c4 10             	add    $0x10,%esp

  unlink("sharedfd");
     e8e:	83 ec 0c             	sub    $0xc,%esp
     e91:	68 6a 49 00 00       	push   $0x496a
     e96:	e8 80 30 00 00       	call   3f1b <unlink>
     e9b:	83 c4 10             	add    $0x10,%esp
  fd = open("sharedfd", O_CREATE|O_RDWR);
     e9e:	83 ec 08             	sub    $0x8,%esp
     ea1:	68 02 02 00 00       	push   $0x202
     ea6:	68 6a 49 00 00       	push   $0x496a
     eab:	e8 5b 30 00 00       	call   3f0b <open>
     eb0:	83 c4 10             	add    $0x10,%esp
     eb3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     eb6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     eba:	79 17                	jns    ed3 <sharedfd+0x5d>
    printf(1, "fstests: cannot open sharedfd for writing");
     ebc:	83 ec 08             	sub    $0x8,%esp
     ebf:	68 74 49 00 00       	push   $0x4974
     ec4:	6a 01                	push   $0x1
     ec6:	e8 73 31 00 00       	call   403e <printf>
     ecb:	83 c4 10             	add    $0x10,%esp
    return;
     ece:	e9 84 01 00 00       	jmp    1057 <sharedfd+0x1e1>
  }
  pid = fork();
     ed3:	e8 eb 2f 00 00       	call   3ec3 <fork>
     ed8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     edb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     edf:	75 07                	jne    ee8 <sharedfd+0x72>
     ee1:	b8 63 00 00 00       	mov    $0x63,%eax
     ee6:	eb 05                	jmp    eed <sharedfd+0x77>
     ee8:	b8 70 00 00 00       	mov    $0x70,%eax
     eed:	83 ec 04             	sub    $0x4,%esp
     ef0:	6a 0a                	push   $0xa
     ef2:	50                   	push   %eax
     ef3:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     ef6:	50                   	push   %eax
     ef7:	e8 34 2e 00 00       	call   3d30 <memset>
     efc:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 1000; i++){
     eff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     f06:	eb 31                	jmp    f39 <sharedfd+0xc3>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     f08:	83 ec 04             	sub    $0x4,%esp
     f0b:	6a 0a                	push   $0xa
     f0d:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     f10:	50                   	push   %eax
     f11:	ff 75 e8             	pushl  -0x18(%ebp)
     f14:	e8 d2 2f 00 00       	call   3eeb <write>
     f19:	83 c4 10             	add    $0x10,%esp
     f1c:	83 f8 0a             	cmp    $0xa,%eax
     f1f:	74 14                	je     f35 <sharedfd+0xbf>
      printf(1, "fstests: write sharedfd failed\n");
     f21:	83 ec 08             	sub    $0x8,%esp
     f24:	68 a0 49 00 00       	push   $0x49a0
     f29:	6a 01                	push   $0x1
     f2b:	e8 0e 31 00 00       	call   403e <printf>
     f30:	83 c4 10             	add    $0x10,%esp
      break;
     f33:	eb 0d                	jmp    f42 <sharedfd+0xcc>
  for(i = 0; i < 1000; i++){
     f35:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     f39:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
     f40:	7e c6                	jle    f08 <sharedfd+0x92>
    }
  }
  if(pid == 0)
     f42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     f46:	75 05                	jne    f4d <sharedfd+0xd7>
    exit();
     f48:	e8 7e 2f 00 00       	call   3ecb <exit>
  else
    wait();
     f4d:	e8 81 2f 00 00       	call   3ed3 <wait>
  close(fd);
     f52:	83 ec 0c             	sub    $0xc,%esp
     f55:	ff 75 e8             	pushl  -0x18(%ebp)
     f58:	e8 96 2f 00 00       	call   3ef3 <close>
     f5d:	83 c4 10             	add    $0x10,%esp
  fd = open("sharedfd", 0);
     f60:	83 ec 08             	sub    $0x8,%esp
     f63:	6a 00                	push   $0x0
     f65:	68 6a 49 00 00       	push   $0x496a
     f6a:	e8 9c 2f 00 00       	call   3f0b <open>
     f6f:	83 c4 10             	add    $0x10,%esp
     f72:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     f75:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     f79:	79 17                	jns    f92 <sharedfd+0x11c>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     f7b:	83 ec 08             	sub    $0x8,%esp
     f7e:	68 c0 49 00 00       	push   $0x49c0
     f83:	6a 01                	push   $0x1
     f85:	e8 b4 30 00 00       	call   403e <printf>
     f8a:	83 c4 10             	add    $0x10,%esp
    return;
     f8d:	e9 c5 00 00 00       	jmp    1057 <sharedfd+0x1e1>
  }
  nc = np = 0;
     f92:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     f99:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f9f:	eb 3b                	jmp    fdc <sharedfd+0x166>
    for(i = 0; i < sizeof(buf); i++){
     fa1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     fa8:	eb 2a                	jmp    fd4 <sharedfd+0x15e>
      if(buf[i] == 'c')
     faa:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fb0:	01 d0                	add    %edx,%eax
     fb2:	0f b6 00             	movzbl (%eax),%eax
     fb5:	3c 63                	cmp    $0x63,%al
     fb7:	75 04                	jne    fbd <sharedfd+0x147>
        nc++;
     fb9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(buf[i] == 'p')
     fbd:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fc3:	01 d0                	add    %edx,%eax
     fc5:	0f b6 00             	movzbl (%eax),%eax
     fc8:	3c 70                	cmp    $0x70,%al
     fca:	75 04                	jne    fd0 <sharedfd+0x15a>
        np++;
     fcc:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    for(i = 0; i < sizeof(buf); i++){
     fd0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fd7:	83 f8 09             	cmp    $0x9,%eax
     fda:	76 ce                	jbe    faa <sharedfd+0x134>
  while((n = read(fd, buf, sizeof(buf))) > 0){
     fdc:	83 ec 04             	sub    $0x4,%esp
     fdf:	6a 0a                	push   $0xa
     fe1:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     fe4:	50                   	push   %eax
     fe5:	ff 75 e8             	pushl  -0x18(%ebp)
     fe8:	e8 f6 2e 00 00       	call   3ee3 <read>
     fed:	83 c4 10             	add    $0x10,%esp
     ff0:	89 45 e0             	mov    %eax,-0x20(%ebp)
     ff3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     ff7:	7f a8                	jg     fa1 <sharedfd+0x12b>
    }
  }
  close(fd);
     ff9:	83 ec 0c             	sub    $0xc,%esp
     ffc:	ff 75 e8             	pushl  -0x18(%ebp)
     fff:	e8 ef 2e 00 00       	call   3ef3 <close>
    1004:	83 c4 10             	add    $0x10,%esp
  unlink("sharedfd");
    1007:	83 ec 0c             	sub    $0xc,%esp
    100a:	68 6a 49 00 00       	push   $0x496a
    100f:	e8 07 2f 00 00       	call   3f1b <unlink>
    1014:	83 c4 10             	add    $0x10,%esp
  if(nc == 10000 && np == 10000){
    1017:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
    101e:	75 1d                	jne    103d <sharedfd+0x1c7>
    1020:	81 7d ec 10 27 00 00 	cmpl   $0x2710,-0x14(%ebp)
    1027:	75 14                	jne    103d <sharedfd+0x1c7>
    printf(1, "sharedfd ok\n");
    1029:	83 ec 08             	sub    $0x8,%esp
    102c:	68 eb 49 00 00       	push   $0x49eb
    1031:	6a 01                	push   $0x1
    1033:	e8 06 30 00 00       	call   403e <printf>
    1038:	83 c4 10             	add    $0x10,%esp
    103b:	eb 1a                	jmp    1057 <sharedfd+0x1e1>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    103d:	ff 75 ec             	pushl  -0x14(%ebp)
    1040:	ff 75 f0             	pushl  -0x10(%ebp)
    1043:	68 f8 49 00 00       	push   $0x49f8
    1048:	6a 01                	push   $0x1
    104a:	e8 ef 2f 00 00       	call   403e <printf>
    104f:	83 c4 10             	add    $0x10,%esp
    exit();
    1052:	e8 74 2e 00 00       	call   3ecb <exit>
  }
}
    1057:	c9                   	leave  
    1058:	c3                   	ret    

00001059 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    1059:	55                   	push   %ebp
    105a:	89 e5                	mov    %esp,%ebp
    105c:	83 ec 38             	sub    $0x38,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    105f:	c7 45 c8 0d 4a 00 00 	movl   $0x4a0d,-0x38(%ebp)
    1066:	c7 45 cc 10 4a 00 00 	movl   $0x4a10,-0x34(%ebp)
    106d:	c7 45 d0 13 4a 00 00 	movl   $0x4a13,-0x30(%ebp)
    1074:	c7 45 d4 16 4a 00 00 	movl   $0x4a16,-0x2c(%ebp)
  char *fname;

  printf(1, "fourfiles test\n");
    107b:	83 ec 08             	sub    $0x8,%esp
    107e:	68 19 4a 00 00       	push   $0x4a19
    1083:	6a 01                	push   $0x1
    1085:	e8 b4 2f 00 00       	call   403e <printf>
    108a:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    108d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    1094:	e9 f0 00 00 00       	jmp    1189 <fourfiles+0x130>
    fname = names[pi];
    1099:	8b 45 e8             	mov    -0x18(%ebp),%eax
    109c:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    10a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    unlink(fname);
    10a3:	83 ec 0c             	sub    $0xc,%esp
    10a6:	ff 75 e4             	pushl  -0x1c(%ebp)
    10a9:	e8 6d 2e 00 00       	call   3f1b <unlink>
    10ae:	83 c4 10             	add    $0x10,%esp

    pid = fork();
    10b1:	e8 0d 2e 00 00       	call   3ec3 <fork>
    10b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if(pid < 0){
    10b9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    10bd:	79 17                	jns    10d6 <fourfiles+0x7d>
      printf(1, "fork failed\n");
    10bf:	83 ec 08             	sub    $0x8,%esp
    10c2:	68 95 44 00 00       	push   $0x4495
    10c7:	6a 01                	push   $0x1
    10c9:	e8 70 2f 00 00       	call   403e <printf>
    10ce:	83 c4 10             	add    $0x10,%esp
      exit();
    10d1:	e8 f5 2d 00 00       	call   3ecb <exit>
    }

    if(pid == 0){
    10d6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    10da:	0f 85 a5 00 00 00    	jne    1185 <fourfiles+0x12c>
      fd = open(fname, O_CREATE | O_RDWR);
    10e0:	83 ec 08             	sub    $0x8,%esp
    10e3:	68 02 02 00 00       	push   $0x202
    10e8:	ff 75 e4             	pushl  -0x1c(%ebp)
    10eb:	e8 1b 2e 00 00       	call   3f0b <open>
    10f0:	83 c4 10             	add    $0x10,%esp
    10f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
      if(fd < 0){
    10f6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
    10fa:	79 17                	jns    1113 <fourfiles+0xba>
        printf(1, "create failed\n");
    10fc:	83 ec 08             	sub    $0x8,%esp
    10ff:	68 29 4a 00 00       	push   $0x4a29
    1104:	6a 01                	push   $0x1
    1106:	e8 33 2f 00 00       	call   403e <printf>
    110b:	83 c4 10             	add    $0x10,%esp
        exit();
    110e:	e8 b8 2d 00 00       	call   3ecb <exit>
      }
      
      memset(buf, '0'+pi, 512);
    1113:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1116:	83 c0 30             	add    $0x30,%eax
    1119:	83 ec 04             	sub    $0x4,%esp
    111c:	68 00 02 00 00       	push   $0x200
    1121:	50                   	push   %eax
    1122:	68 a0 8a 00 00       	push   $0x8aa0
    1127:	e8 04 2c 00 00       	call   3d30 <memset>
    112c:	83 c4 10             	add    $0x10,%esp
      for(i = 0; i < 12; i++){
    112f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1136:	eb 42                	jmp    117a <fourfiles+0x121>
        if((n = write(fd, buf, 500)) != 500){
    1138:	83 ec 04             	sub    $0x4,%esp
    113b:	68 f4 01 00 00       	push   $0x1f4
    1140:	68 a0 8a 00 00       	push   $0x8aa0
    1145:	ff 75 dc             	pushl  -0x24(%ebp)
    1148:	e8 9e 2d 00 00       	call   3eeb <write>
    114d:	83 c4 10             	add    $0x10,%esp
    1150:	89 45 d8             	mov    %eax,-0x28(%ebp)
    1153:	81 7d d8 f4 01 00 00 	cmpl   $0x1f4,-0x28(%ebp)
    115a:	74 1a                	je     1176 <fourfiles+0x11d>
          printf(1, "write failed %d\n", n);
    115c:	83 ec 04             	sub    $0x4,%esp
    115f:	ff 75 d8             	pushl  -0x28(%ebp)
    1162:	68 38 4a 00 00       	push   $0x4a38
    1167:	6a 01                	push   $0x1
    1169:	e8 d0 2e 00 00       	call   403e <printf>
    116e:	83 c4 10             	add    $0x10,%esp
          exit();
    1171:	e8 55 2d 00 00       	call   3ecb <exit>
      for(i = 0; i < 12; i++){
    1176:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    117a:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
    117e:	7e b8                	jle    1138 <fourfiles+0xdf>
        }
      }
      exit();
    1180:	e8 46 2d 00 00       	call   3ecb <exit>
  for(pi = 0; pi < 4; pi++){
    1185:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    1189:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    118d:	0f 8e 06 ff ff ff    	jle    1099 <fourfiles+0x40>
    }
  }

  for(pi = 0; pi < 4; pi++){
    1193:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    119a:	eb 09                	jmp    11a5 <fourfiles+0x14c>
    wait();
    119c:	e8 32 2d 00 00       	call   3ed3 <wait>
  for(pi = 0; pi < 4; pi++){
    11a1:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    11a5:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    11a9:	7e f1                	jle    119c <fourfiles+0x143>
  }

  for(i = 0; i < 2; i++){
    11ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11b2:	e9 d4 00 00 00       	jmp    128b <fourfiles+0x232>
    fname = names[i];
    11b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11ba:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    11be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    fd = open(fname, 0);
    11c1:	83 ec 08             	sub    $0x8,%esp
    11c4:	6a 00                	push   $0x0
    11c6:	ff 75 e4             	pushl  -0x1c(%ebp)
    11c9:	e8 3d 2d 00 00       	call   3f0b <open>
    11ce:	83 c4 10             	add    $0x10,%esp
    11d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    total = 0;
    11d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    11db:	eb 4a                	jmp    1227 <fourfiles+0x1ce>
      for(j = 0; j < n; j++){
    11dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    11e4:	eb 33                	jmp    1219 <fourfiles+0x1c0>
        if(buf[j] != '0'+i){
    11e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11e9:	05 a0 8a 00 00       	add    $0x8aa0,%eax
    11ee:	0f b6 00             	movzbl (%eax),%eax
    11f1:	0f be c0             	movsbl %al,%eax
    11f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11f7:	83 c2 30             	add    $0x30,%edx
    11fa:	39 d0                	cmp    %edx,%eax
    11fc:	74 17                	je     1215 <fourfiles+0x1bc>
          printf(1, "wrong char\n");
    11fe:	83 ec 08             	sub    $0x8,%esp
    1201:	68 49 4a 00 00       	push   $0x4a49
    1206:	6a 01                	push   $0x1
    1208:	e8 31 2e 00 00       	call   403e <printf>
    120d:	83 c4 10             	add    $0x10,%esp
          exit();
    1210:	e8 b6 2c 00 00       	call   3ecb <exit>
      for(j = 0; j < n; j++){
    1215:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1219:	8b 45 f0             	mov    -0x10(%ebp),%eax
    121c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
    121f:	7c c5                	jl     11e6 <fourfiles+0x18d>
        }
      }
      total += n;
    1221:	8b 45 d8             	mov    -0x28(%ebp),%eax
    1224:	01 45 ec             	add    %eax,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1227:	83 ec 04             	sub    $0x4,%esp
    122a:	68 00 20 00 00       	push   $0x2000
    122f:	68 a0 8a 00 00       	push   $0x8aa0
    1234:	ff 75 dc             	pushl  -0x24(%ebp)
    1237:	e8 a7 2c 00 00       	call   3ee3 <read>
    123c:	83 c4 10             	add    $0x10,%esp
    123f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    1242:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
    1246:	7f 95                	jg     11dd <fourfiles+0x184>
    }
    close(fd);
    1248:	83 ec 0c             	sub    $0xc,%esp
    124b:	ff 75 dc             	pushl  -0x24(%ebp)
    124e:	e8 a0 2c 00 00       	call   3ef3 <close>
    1253:	83 c4 10             	add    $0x10,%esp
    if(total != 12*500){
    1256:	81 7d ec 70 17 00 00 	cmpl   $0x1770,-0x14(%ebp)
    125d:	74 1a                	je     1279 <fourfiles+0x220>
      printf(1, "wrong length %d\n", total);
    125f:	83 ec 04             	sub    $0x4,%esp
    1262:	ff 75 ec             	pushl  -0x14(%ebp)
    1265:	68 55 4a 00 00       	push   $0x4a55
    126a:	6a 01                	push   $0x1
    126c:	e8 cd 2d 00 00       	call   403e <printf>
    1271:	83 c4 10             	add    $0x10,%esp
      exit();
    1274:	e8 52 2c 00 00       	call   3ecb <exit>
    }
    unlink(fname);
    1279:	83 ec 0c             	sub    $0xc,%esp
    127c:	ff 75 e4             	pushl  -0x1c(%ebp)
    127f:	e8 97 2c 00 00       	call   3f1b <unlink>
    1284:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 2; i++){
    1287:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    128b:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
    128f:	0f 8e 22 ff ff ff    	jle    11b7 <fourfiles+0x15e>
  }

  printf(1, "fourfiles ok\n");
    1295:	83 ec 08             	sub    $0x8,%esp
    1298:	68 66 4a 00 00       	push   $0x4a66
    129d:	6a 01                	push   $0x1
    129f:	e8 9a 2d 00 00       	call   403e <printf>
    12a4:	83 c4 10             	add    $0x10,%esp
}
    12a7:	90                   	nop
    12a8:	c9                   	leave  
    12a9:	c3                   	ret    

000012aa <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    12aa:	55                   	push   %ebp
    12ab:	89 e5                	mov    %esp,%ebp
    12ad:	83 ec 38             	sub    $0x38,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    12b0:	83 ec 08             	sub    $0x8,%esp
    12b3:	68 74 4a 00 00       	push   $0x4a74
    12b8:	6a 01                	push   $0x1
    12ba:	e8 7f 2d 00 00       	call   403e <printf>
    12bf:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    12c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    12c9:	e9 f6 00 00 00       	jmp    13c4 <createdelete+0x11a>
    pid = fork();
    12ce:	e8 f0 2b 00 00       	call   3ec3 <fork>
    12d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    12d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    12da:	79 17                	jns    12f3 <createdelete+0x49>
      printf(1, "fork failed\n");
    12dc:	83 ec 08             	sub    $0x8,%esp
    12df:	68 95 44 00 00       	push   $0x4495
    12e4:	6a 01                	push   $0x1
    12e6:	e8 53 2d 00 00       	call   403e <printf>
    12eb:	83 c4 10             	add    $0x10,%esp
      exit();
    12ee:	e8 d8 2b 00 00       	call   3ecb <exit>
    }

    if(pid == 0){
    12f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    12f7:	0f 85 c3 00 00 00    	jne    13c0 <createdelete+0x116>
      name[0] = 'p' + pi;
    12fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1300:	83 c0 70             	add    $0x70,%eax
    1303:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[2] = '\0';
    1306:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
      for(i = 0; i < N; i++){
    130a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1311:	e9 9b 00 00 00       	jmp    13b1 <createdelete+0x107>
        name[1] = '0' + i;
    1316:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1319:	83 c0 30             	add    $0x30,%eax
    131c:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    131f:	83 ec 08             	sub    $0x8,%esp
    1322:	68 02 02 00 00       	push   $0x202
    1327:	8d 45 c8             	lea    -0x38(%ebp),%eax
    132a:	50                   	push   %eax
    132b:	e8 db 2b 00 00       	call   3f0b <open>
    1330:	83 c4 10             	add    $0x10,%esp
    1333:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if(fd < 0){
    1336:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    133a:	79 17                	jns    1353 <createdelete+0xa9>
          printf(1, "create failed\n");
    133c:	83 ec 08             	sub    $0x8,%esp
    133f:	68 29 4a 00 00       	push   $0x4a29
    1344:	6a 01                	push   $0x1
    1346:	e8 f3 2c 00 00       	call   403e <printf>
    134b:	83 c4 10             	add    $0x10,%esp
          exit();
    134e:	e8 78 2b 00 00       	call   3ecb <exit>
        }
        close(fd);
    1353:	83 ec 0c             	sub    $0xc,%esp
    1356:	ff 75 e8             	pushl  -0x18(%ebp)
    1359:	e8 95 2b 00 00       	call   3ef3 <close>
    135e:	83 c4 10             	add    $0x10,%esp
        if(i > 0 && (i % 2 ) == 0){
    1361:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1365:	7e 46                	jle    13ad <createdelete+0x103>
    1367:	8b 45 f4             	mov    -0xc(%ebp),%eax
    136a:	83 e0 01             	and    $0x1,%eax
    136d:	85 c0                	test   %eax,%eax
    136f:	75 3c                	jne    13ad <createdelete+0x103>
          name[1] = '0' + (i / 2);
    1371:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1374:	89 c2                	mov    %eax,%edx
    1376:	c1 ea 1f             	shr    $0x1f,%edx
    1379:	01 d0                	add    %edx,%eax
    137b:	d1 f8                	sar    %eax
    137d:	83 c0 30             	add    $0x30,%eax
    1380:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    1383:	83 ec 0c             	sub    $0xc,%esp
    1386:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1389:	50                   	push   %eax
    138a:	e8 8c 2b 00 00       	call   3f1b <unlink>
    138f:	83 c4 10             	add    $0x10,%esp
    1392:	85 c0                	test   %eax,%eax
    1394:	79 17                	jns    13ad <createdelete+0x103>
            printf(1, "unlink failed\n");
    1396:	83 ec 08             	sub    $0x8,%esp
    1399:	68 18 45 00 00       	push   $0x4518
    139e:	6a 01                	push   $0x1
    13a0:	e8 99 2c 00 00       	call   403e <printf>
    13a5:	83 c4 10             	add    $0x10,%esp
            exit();
    13a8:	e8 1e 2b 00 00       	call   3ecb <exit>
      for(i = 0; i < N; i++){
    13ad:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    13b1:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    13b5:	0f 8e 5b ff ff ff    	jle    1316 <createdelete+0x6c>
          }
        }
      }
      exit();
    13bb:	e8 0b 2b 00 00       	call   3ecb <exit>
  for(pi = 0; pi < 4; pi++){
    13c0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    13c4:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    13c8:	0f 8e 00 ff ff ff    	jle    12ce <createdelete+0x24>
    }
  }

  for(pi = 0; pi < 4; pi++){
    13ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    13d5:	eb 09                	jmp    13e0 <createdelete+0x136>
    wait();
    13d7:	e8 f7 2a 00 00       	call   3ed3 <wait>
  for(pi = 0; pi < 4; pi++){
    13dc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    13e0:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    13e4:	7e f1                	jle    13d7 <createdelete+0x12d>
  }

  name[0] = name[1] = name[2] = 0;
    13e6:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    13ea:	0f b6 45 ca          	movzbl -0x36(%ebp),%eax
    13ee:	88 45 c9             	mov    %al,-0x37(%ebp)
    13f1:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
    13f5:	88 45 c8             	mov    %al,-0x38(%ebp)
  for(i = 0; i < N; i++){
    13f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    13ff:	e9 b2 00 00 00       	jmp    14b6 <createdelete+0x20c>
    for(pi = 0; pi < 4; pi++){
    1404:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    140b:	e9 98 00 00 00       	jmp    14a8 <createdelete+0x1fe>
      name[0] = 'p' + pi;
    1410:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1413:	83 c0 70             	add    $0x70,%eax
    1416:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    1419:	8b 45 f4             	mov    -0xc(%ebp),%eax
    141c:	83 c0 30             	add    $0x30,%eax
    141f:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    1422:	83 ec 08             	sub    $0x8,%esp
    1425:	6a 00                	push   $0x0
    1427:	8d 45 c8             	lea    -0x38(%ebp),%eax
    142a:	50                   	push   %eax
    142b:	e8 db 2a 00 00       	call   3f0b <open>
    1430:	83 c4 10             	add    $0x10,%esp
    1433:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((i == 0 || i >= N/2) && fd < 0){
    1436:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    143a:	74 06                	je     1442 <createdelete+0x198>
    143c:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    1440:	7e 21                	jle    1463 <createdelete+0x1b9>
    1442:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1446:	79 1b                	jns    1463 <createdelete+0x1b9>
        printf(1, "oops createdelete %s didn't exist\n", name);
    1448:	83 ec 04             	sub    $0x4,%esp
    144b:	8d 45 c8             	lea    -0x38(%ebp),%eax
    144e:	50                   	push   %eax
    144f:	68 88 4a 00 00       	push   $0x4a88
    1454:	6a 01                	push   $0x1
    1456:	e8 e3 2b 00 00       	call   403e <printf>
    145b:	83 c4 10             	add    $0x10,%esp
        exit();
    145e:	e8 68 2a 00 00       	call   3ecb <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1463:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1467:	7e 27                	jle    1490 <createdelete+0x1e6>
    1469:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    146d:	7f 21                	jg     1490 <createdelete+0x1e6>
    146f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1473:	78 1b                	js     1490 <createdelete+0x1e6>
        printf(1, "oops createdelete %s did exist\n", name);
    1475:	83 ec 04             	sub    $0x4,%esp
    1478:	8d 45 c8             	lea    -0x38(%ebp),%eax
    147b:	50                   	push   %eax
    147c:	68 ac 4a 00 00       	push   $0x4aac
    1481:	6a 01                	push   $0x1
    1483:	e8 b6 2b 00 00       	call   403e <printf>
    1488:	83 c4 10             	add    $0x10,%esp
        exit();
    148b:	e8 3b 2a 00 00       	call   3ecb <exit>
      }
      if(fd >= 0)
    1490:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1494:	78 0e                	js     14a4 <createdelete+0x1fa>
        close(fd);
    1496:	83 ec 0c             	sub    $0xc,%esp
    1499:	ff 75 e8             	pushl  -0x18(%ebp)
    149c:	e8 52 2a 00 00       	call   3ef3 <close>
    14a1:	83 c4 10             	add    $0x10,%esp
    for(pi = 0; pi < 4; pi++){
    14a4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    14a8:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    14ac:	0f 8e 5e ff ff ff    	jle    1410 <createdelete+0x166>
  for(i = 0; i < N; i++){
    14b2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    14b6:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    14ba:	0f 8e 44 ff ff ff    	jle    1404 <createdelete+0x15a>
    }
  }

  for(i = 0; i < N; i++){
    14c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    14c7:	eb 38                	jmp    1501 <createdelete+0x257>
    for(pi = 0; pi < 4; pi++){
    14c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    14d0:	eb 25                	jmp    14f7 <createdelete+0x24d>
      name[0] = 'p' + i;
    14d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14d5:	83 c0 70             	add    $0x70,%eax
    14d8:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    14db:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14de:	83 c0 30             	add    $0x30,%eax
    14e1:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    14e4:	83 ec 0c             	sub    $0xc,%esp
    14e7:	8d 45 c8             	lea    -0x38(%ebp),%eax
    14ea:	50                   	push   %eax
    14eb:	e8 2b 2a 00 00       	call   3f1b <unlink>
    14f0:	83 c4 10             	add    $0x10,%esp
    for(pi = 0; pi < 4; pi++){
    14f3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    14f7:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    14fb:	7e d5                	jle    14d2 <createdelete+0x228>
  for(i = 0; i < N; i++){
    14fd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1501:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    1505:	7e c2                	jle    14c9 <createdelete+0x21f>
    }
  }

  printf(1, "createdelete ok\n");
    1507:	83 ec 08             	sub    $0x8,%esp
    150a:	68 cc 4a 00 00       	push   $0x4acc
    150f:	6a 01                	push   $0x1
    1511:	e8 28 2b 00 00       	call   403e <printf>
    1516:	83 c4 10             	add    $0x10,%esp
}
    1519:	90                   	nop
    151a:	c9                   	leave  
    151b:	c3                   	ret    

0000151c <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    151c:	55                   	push   %ebp
    151d:	89 e5                	mov    %esp,%ebp
    151f:	83 ec 18             	sub    $0x18,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    1522:	83 ec 08             	sub    $0x8,%esp
    1525:	68 dd 4a 00 00       	push   $0x4add
    152a:	6a 01                	push   $0x1
    152c:	e8 0d 2b 00 00       	call   403e <printf>
    1531:	83 c4 10             	add    $0x10,%esp
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1534:	83 ec 08             	sub    $0x8,%esp
    1537:	68 02 02 00 00       	push   $0x202
    153c:	68 ee 4a 00 00       	push   $0x4aee
    1541:	e8 c5 29 00 00       	call   3f0b <open>
    1546:	83 c4 10             	add    $0x10,%esp
    1549:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    154c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1550:	79 17                	jns    1569 <unlinkread+0x4d>
    printf(1, "create unlinkread failed\n");
    1552:	83 ec 08             	sub    $0x8,%esp
    1555:	68 f9 4a 00 00       	push   $0x4af9
    155a:	6a 01                	push   $0x1
    155c:	e8 dd 2a 00 00       	call   403e <printf>
    1561:	83 c4 10             	add    $0x10,%esp
    exit();
    1564:	e8 62 29 00 00       	call   3ecb <exit>
  }
  write(fd, "hello", 5);
    1569:	83 ec 04             	sub    $0x4,%esp
    156c:	6a 05                	push   $0x5
    156e:	68 13 4b 00 00       	push   $0x4b13
    1573:	ff 75 f4             	pushl  -0xc(%ebp)
    1576:	e8 70 29 00 00       	call   3eeb <write>
    157b:	83 c4 10             	add    $0x10,%esp
  close(fd);
    157e:	83 ec 0c             	sub    $0xc,%esp
    1581:	ff 75 f4             	pushl  -0xc(%ebp)
    1584:	e8 6a 29 00 00       	call   3ef3 <close>
    1589:	83 c4 10             	add    $0x10,%esp

  fd = open("unlinkread", O_RDWR);
    158c:	83 ec 08             	sub    $0x8,%esp
    158f:	6a 02                	push   $0x2
    1591:	68 ee 4a 00 00       	push   $0x4aee
    1596:	e8 70 29 00 00       	call   3f0b <open>
    159b:	83 c4 10             	add    $0x10,%esp
    159e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    15a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15a5:	79 17                	jns    15be <unlinkread+0xa2>
    printf(1, "open unlinkread failed\n");
    15a7:	83 ec 08             	sub    $0x8,%esp
    15aa:	68 19 4b 00 00       	push   $0x4b19
    15af:	6a 01                	push   $0x1
    15b1:	e8 88 2a 00 00       	call   403e <printf>
    15b6:	83 c4 10             	add    $0x10,%esp
    exit();
    15b9:	e8 0d 29 00 00       	call   3ecb <exit>
  }
  if(unlink("unlinkread") != 0){
    15be:	83 ec 0c             	sub    $0xc,%esp
    15c1:	68 ee 4a 00 00       	push   $0x4aee
    15c6:	e8 50 29 00 00       	call   3f1b <unlink>
    15cb:	83 c4 10             	add    $0x10,%esp
    15ce:	85 c0                	test   %eax,%eax
    15d0:	74 17                	je     15e9 <unlinkread+0xcd>
    printf(1, "unlink unlinkread failed\n");
    15d2:	83 ec 08             	sub    $0x8,%esp
    15d5:	68 31 4b 00 00       	push   $0x4b31
    15da:	6a 01                	push   $0x1
    15dc:	e8 5d 2a 00 00       	call   403e <printf>
    15e1:	83 c4 10             	add    $0x10,%esp
    exit();
    15e4:	e8 e2 28 00 00       	call   3ecb <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    15e9:	83 ec 08             	sub    $0x8,%esp
    15ec:	68 02 02 00 00       	push   $0x202
    15f1:	68 ee 4a 00 00       	push   $0x4aee
    15f6:	e8 10 29 00 00       	call   3f0b <open>
    15fb:	83 c4 10             	add    $0x10,%esp
    15fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  write(fd1, "yyy", 3);
    1601:	83 ec 04             	sub    $0x4,%esp
    1604:	6a 03                	push   $0x3
    1606:	68 4b 4b 00 00       	push   $0x4b4b
    160b:	ff 75 f0             	pushl  -0x10(%ebp)
    160e:	e8 d8 28 00 00       	call   3eeb <write>
    1613:	83 c4 10             	add    $0x10,%esp
  close(fd1);
    1616:	83 ec 0c             	sub    $0xc,%esp
    1619:	ff 75 f0             	pushl  -0x10(%ebp)
    161c:	e8 d2 28 00 00       	call   3ef3 <close>
    1621:	83 c4 10             	add    $0x10,%esp

  if(read(fd, buf, sizeof(buf)) != 5){
    1624:	83 ec 04             	sub    $0x4,%esp
    1627:	68 00 20 00 00       	push   $0x2000
    162c:	68 a0 8a 00 00       	push   $0x8aa0
    1631:	ff 75 f4             	pushl  -0xc(%ebp)
    1634:	e8 aa 28 00 00       	call   3ee3 <read>
    1639:	83 c4 10             	add    $0x10,%esp
    163c:	83 f8 05             	cmp    $0x5,%eax
    163f:	74 17                	je     1658 <unlinkread+0x13c>
    printf(1, "unlinkread read failed");
    1641:	83 ec 08             	sub    $0x8,%esp
    1644:	68 4f 4b 00 00       	push   $0x4b4f
    1649:	6a 01                	push   $0x1
    164b:	e8 ee 29 00 00       	call   403e <printf>
    1650:	83 c4 10             	add    $0x10,%esp
    exit();
    1653:	e8 73 28 00 00       	call   3ecb <exit>
  }
  if(buf[0] != 'h'){
    1658:	0f b6 05 a0 8a 00 00 	movzbl 0x8aa0,%eax
    165f:	3c 68                	cmp    $0x68,%al
    1661:	74 17                	je     167a <unlinkread+0x15e>
    printf(1, "unlinkread wrong data\n");
    1663:	83 ec 08             	sub    $0x8,%esp
    1666:	68 66 4b 00 00       	push   $0x4b66
    166b:	6a 01                	push   $0x1
    166d:	e8 cc 29 00 00       	call   403e <printf>
    1672:	83 c4 10             	add    $0x10,%esp
    exit();
    1675:	e8 51 28 00 00       	call   3ecb <exit>
  }
  if(write(fd, buf, 10) != 10){
    167a:	83 ec 04             	sub    $0x4,%esp
    167d:	6a 0a                	push   $0xa
    167f:	68 a0 8a 00 00       	push   $0x8aa0
    1684:	ff 75 f4             	pushl  -0xc(%ebp)
    1687:	e8 5f 28 00 00       	call   3eeb <write>
    168c:	83 c4 10             	add    $0x10,%esp
    168f:	83 f8 0a             	cmp    $0xa,%eax
    1692:	74 17                	je     16ab <unlinkread+0x18f>
    printf(1, "unlinkread write failed\n");
    1694:	83 ec 08             	sub    $0x8,%esp
    1697:	68 7d 4b 00 00       	push   $0x4b7d
    169c:	6a 01                	push   $0x1
    169e:	e8 9b 29 00 00       	call   403e <printf>
    16a3:	83 c4 10             	add    $0x10,%esp
    exit();
    16a6:	e8 20 28 00 00       	call   3ecb <exit>
  }
  close(fd);
    16ab:	83 ec 0c             	sub    $0xc,%esp
    16ae:	ff 75 f4             	pushl  -0xc(%ebp)
    16b1:	e8 3d 28 00 00       	call   3ef3 <close>
    16b6:	83 c4 10             	add    $0x10,%esp
  unlink("unlinkread");
    16b9:	83 ec 0c             	sub    $0xc,%esp
    16bc:	68 ee 4a 00 00       	push   $0x4aee
    16c1:	e8 55 28 00 00       	call   3f1b <unlink>
    16c6:	83 c4 10             	add    $0x10,%esp
  printf(1, "unlinkread ok\n");
    16c9:	83 ec 08             	sub    $0x8,%esp
    16cc:	68 96 4b 00 00       	push   $0x4b96
    16d1:	6a 01                	push   $0x1
    16d3:	e8 66 29 00 00       	call   403e <printf>
    16d8:	83 c4 10             	add    $0x10,%esp
}
    16db:	90                   	nop
    16dc:	c9                   	leave  
    16dd:	c3                   	ret    

000016de <linktest>:

void
linktest(void)
{
    16de:	55                   	push   %ebp
    16df:	89 e5                	mov    %esp,%ebp
    16e1:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(1, "linktest\n");
    16e4:	83 ec 08             	sub    $0x8,%esp
    16e7:	68 a5 4b 00 00       	push   $0x4ba5
    16ec:	6a 01                	push   $0x1
    16ee:	e8 4b 29 00 00       	call   403e <printf>
    16f3:	83 c4 10             	add    $0x10,%esp

  unlink("lf1");
    16f6:	83 ec 0c             	sub    $0xc,%esp
    16f9:	68 af 4b 00 00       	push   $0x4baf
    16fe:	e8 18 28 00 00       	call   3f1b <unlink>
    1703:	83 c4 10             	add    $0x10,%esp
  unlink("lf2");
    1706:	83 ec 0c             	sub    $0xc,%esp
    1709:	68 b3 4b 00 00       	push   $0x4bb3
    170e:	e8 08 28 00 00       	call   3f1b <unlink>
    1713:	83 c4 10             	add    $0x10,%esp

  fd = open("lf1", O_CREATE|O_RDWR);
    1716:	83 ec 08             	sub    $0x8,%esp
    1719:	68 02 02 00 00       	push   $0x202
    171e:	68 af 4b 00 00       	push   $0x4baf
    1723:	e8 e3 27 00 00       	call   3f0b <open>
    1728:	83 c4 10             	add    $0x10,%esp
    172b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    172e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1732:	79 17                	jns    174b <linktest+0x6d>
    printf(1, "create lf1 failed\n");
    1734:	83 ec 08             	sub    $0x8,%esp
    1737:	68 b7 4b 00 00       	push   $0x4bb7
    173c:	6a 01                	push   $0x1
    173e:	e8 fb 28 00 00       	call   403e <printf>
    1743:	83 c4 10             	add    $0x10,%esp
    exit();
    1746:	e8 80 27 00 00       	call   3ecb <exit>
  }
  if(write(fd, "hello", 5) != 5){
    174b:	83 ec 04             	sub    $0x4,%esp
    174e:	6a 05                	push   $0x5
    1750:	68 13 4b 00 00       	push   $0x4b13
    1755:	ff 75 f4             	pushl  -0xc(%ebp)
    1758:	e8 8e 27 00 00       	call   3eeb <write>
    175d:	83 c4 10             	add    $0x10,%esp
    1760:	83 f8 05             	cmp    $0x5,%eax
    1763:	74 17                	je     177c <linktest+0x9e>
    printf(1, "write lf1 failed\n");
    1765:	83 ec 08             	sub    $0x8,%esp
    1768:	68 ca 4b 00 00       	push   $0x4bca
    176d:	6a 01                	push   $0x1
    176f:	e8 ca 28 00 00       	call   403e <printf>
    1774:	83 c4 10             	add    $0x10,%esp
    exit();
    1777:	e8 4f 27 00 00       	call   3ecb <exit>
  }
  close(fd);
    177c:	83 ec 0c             	sub    $0xc,%esp
    177f:	ff 75 f4             	pushl  -0xc(%ebp)
    1782:	e8 6c 27 00 00       	call   3ef3 <close>
    1787:	83 c4 10             	add    $0x10,%esp

  if(link("lf1", "lf2") < 0){
    178a:	83 ec 08             	sub    $0x8,%esp
    178d:	68 b3 4b 00 00       	push   $0x4bb3
    1792:	68 af 4b 00 00       	push   $0x4baf
    1797:	e8 8f 27 00 00       	call   3f2b <link>
    179c:	83 c4 10             	add    $0x10,%esp
    179f:	85 c0                	test   %eax,%eax
    17a1:	79 17                	jns    17ba <linktest+0xdc>
    printf(1, "link lf1 lf2 failed\n");
    17a3:	83 ec 08             	sub    $0x8,%esp
    17a6:	68 dc 4b 00 00       	push   $0x4bdc
    17ab:	6a 01                	push   $0x1
    17ad:	e8 8c 28 00 00       	call   403e <printf>
    17b2:	83 c4 10             	add    $0x10,%esp
    exit();
    17b5:	e8 11 27 00 00       	call   3ecb <exit>
  }
  unlink("lf1");
    17ba:	83 ec 0c             	sub    $0xc,%esp
    17bd:	68 af 4b 00 00       	push   $0x4baf
    17c2:	e8 54 27 00 00       	call   3f1b <unlink>
    17c7:	83 c4 10             	add    $0x10,%esp

  if(open("lf1", 0) >= 0){
    17ca:	83 ec 08             	sub    $0x8,%esp
    17cd:	6a 00                	push   $0x0
    17cf:	68 af 4b 00 00       	push   $0x4baf
    17d4:	e8 32 27 00 00       	call   3f0b <open>
    17d9:	83 c4 10             	add    $0x10,%esp
    17dc:	85 c0                	test   %eax,%eax
    17de:	78 17                	js     17f7 <linktest+0x119>
    printf(1, "unlinked lf1 but it is still there!\n");
    17e0:	83 ec 08             	sub    $0x8,%esp
    17e3:	68 f4 4b 00 00       	push   $0x4bf4
    17e8:	6a 01                	push   $0x1
    17ea:	e8 4f 28 00 00       	call   403e <printf>
    17ef:	83 c4 10             	add    $0x10,%esp
    exit();
    17f2:	e8 d4 26 00 00       	call   3ecb <exit>
  }

  fd = open("lf2", 0);
    17f7:	83 ec 08             	sub    $0x8,%esp
    17fa:	6a 00                	push   $0x0
    17fc:	68 b3 4b 00 00       	push   $0x4bb3
    1801:	e8 05 27 00 00       	call   3f0b <open>
    1806:	83 c4 10             	add    $0x10,%esp
    1809:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    180c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1810:	79 17                	jns    1829 <linktest+0x14b>
    printf(1, "open lf2 failed\n");
    1812:	83 ec 08             	sub    $0x8,%esp
    1815:	68 19 4c 00 00       	push   $0x4c19
    181a:	6a 01                	push   $0x1
    181c:	e8 1d 28 00 00       	call   403e <printf>
    1821:	83 c4 10             	add    $0x10,%esp
    exit();
    1824:	e8 a2 26 00 00       	call   3ecb <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    1829:	83 ec 04             	sub    $0x4,%esp
    182c:	68 00 20 00 00       	push   $0x2000
    1831:	68 a0 8a 00 00       	push   $0x8aa0
    1836:	ff 75 f4             	pushl  -0xc(%ebp)
    1839:	e8 a5 26 00 00       	call   3ee3 <read>
    183e:	83 c4 10             	add    $0x10,%esp
    1841:	83 f8 05             	cmp    $0x5,%eax
    1844:	74 17                	je     185d <linktest+0x17f>
    printf(1, "read lf2 failed\n");
    1846:	83 ec 08             	sub    $0x8,%esp
    1849:	68 2a 4c 00 00       	push   $0x4c2a
    184e:	6a 01                	push   $0x1
    1850:	e8 e9 27 00 00       	call   403e <printf>
    1855:	83 c4 10             	add    $0x10,%esp
    exit();
    1858:	e8 6e 26 00 00       	call   3ecb <exit>
  }
  close(fd);
    185d:	83 ec 0c             	sub    $0xc,%esp
    1860:	ff 75 f4             	pushl  -0xc(%ebp)
    1863:	e8 8b 26 00 00       	call   3ef3 <close>
    1868:	83 c4 10             	add    $0x10,%esp

  if(link("lf2", "lf2") >= 0){
    186b:	83 ec 08             	sub    $0x8,%esp
    186e:	68 b3 4b 00 00       	push   $0x4bb3
    1873:	68 b3 4b 00 00       	push   $0x4bb3
    1878:	e8 ae 26 00 00       	call   3f2b <link>
    187d:	83 c4 10             	add    $0x10,%esp
    1880:	85 c0                	test   %eax,%eax
    1882:	78 17                	js     189b <linktest+0x1bd>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    1884:	83 ec 08             	sub    $0x8,%esp
    1887:	68 3b 4c 00 00       	push   $0x4c3b
    188c:	6a 01                	push   $0x1
    188e:	e8 ab 27 00 00       	call   403e <printf>
    1893:	83 c4 10             	add    $0x10,%esp
    exit();
    1896:	e8 30 26 00 00       	call   3ecb <exit>
  }

  unlink("lf2");
    189b:	83 ec 0c             	sub    $0xc,%esp
    189e:	68 b3 4b 00 00       	push   $0x4bb3
    18a3:	e8 73 26 00 00       	call   3f1b <unlink>
    18a8:	83 c4 10             	add    $0x10,%esp
  if(link("lf2", "lf1") >= 0){
    18ab:	83 ec 08             	sub    $0x8,%esp
    18ae:	68 af 4b 00 00       	push   $0x4baf
    18b3:	68 b3 4b 00 00       	push   $0x4bb3
    18b8:	e8 6e 26 00 00       	call   3f2b <link>
    18bd:	83 c4 10             	add    $0x10,%esp
    18c0:	85 c0                	test   %eax,%eax
    18c2:	78 17                	js     18db <linktest+0x1fd>
    printf(1, "link non-existant succeeded! oops\n");
    18c4:	83 ec 08             	sub    $0x8,%esp
    18c7:	68 5c 4c 00 00       	push   $0x4c5c
    18cc:	6a 01                	push   $0x1
    18ce:	e8 6b 27 00 00       	call   403e <printf>
    18d3:	83 c4 10             	add    $0x10,%esp
    exit();
    18d6:	e8 f0 25 00 00       	call   3ecb <exit>
  }

  if(link(".", "lf1") >= 0){
    18db:	83 ec 08             	sub    $0x8,%esp
    18de:	68 af 4b 00 00       	push   $0x4baf
    18e3:	68 7f 4c 00 00       	push   $0x4c7f
    18e8:	e8 3e 26 00 00       	call   3f2b <link>
    18ed:	83 c4 10             	add    $0x10,%esp
    18f0:	85 c0                	test   %eax,%eax
    18f2:	78 17                	js     190b <linktest+0x22d>
    printf(1, "link . lf1 succeeded! oops\n");
    18f4:	83 ec 08             	sub    $0x8,%esp
    18f7:	68 81 4c 00 00       	push   $0x4c81
    18fc:	6a 01                	push   $0x1
    18fe:	e8 3b 27 00 00       	call   403e <printf>
    1903:	83 c4 10             	add    $0x10,%esp
    exit();
    1906:	e8 c0 25 00 00       	call   3ecb <exit>
  }

  printf(1, "linktest ok\n");
    190b:	83 ec 08             	sub    $0x8,%esp
    190e:	68 9d 4c 00 00       	push   $0x4c9d
    1913:	6a 01                	push   $0x1
    1915:	e8 24 27 00 00       	call   403e <printf>
    191a:	83 c4 10             	add    $0x10,%esp
}
    191d:	90                   	nop
    191e:	c9                   	leave  
    191f:	c3                   	ret    

00001920 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    1920:	55                   	push   %ebp
    1921:	89 e5                	mov    %esp,%ebp
    1923:	83 ec 58             	sub    $0x58,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    1926:	83 ec 08             	sub    $0x8,%esp
    1929:	68 aa 4c 00 00       	push   $0x4caa
    192e:	6a 01                	push   $0x1
    1930:	e8 09 27 00 00       	call   403e <printf>
    1935:	83 c4 10             	add    $0x10,%esp
  file[0] = 'C';
    1938:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    193c:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    1940:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1947:	e9 fc 00 00 00       	jmp    1a48 <concreate+0x128>
    file[1] = '0' + i;
    194c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    194f:	83 c0 30             	add    $0x30,%eax
    1952:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    1955:	83 ec 0c             	sub    $0xc,%esp
    1958:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    195b:	50                   	push   %eax
    195c:	e8 ba 25 00 00       	call   3f1b <unlink>
    1961:	83 c4 10             	add    $0x10,%esp
    pid = fork();
    1964:	e8 5a 25 00 00       	call   3ec3 <fork>
    1969:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid && (i % 3) == 1){
    196c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1970:	74 3b                	je     19ad <concreate+0x8d>
    1972:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1975:	ba 56 55 55 55       	mov    $0x55555556,%edx
    197a:	89 c8                	mov    %ecx,%eax
    197c:	f7 ea                	imul   %edx
    197e:	89 c8                	mov    %ecx,%eax
    1980:	c1 f8 1f             	sar    $0x1f,%eax
    1983:	29 c2                	sub    %eax,%edx
    1985:	89 d0                	mov    %edx,%eax
    1987:	01 c0                	add    %eax,%eax
    1989:	01 d0                	add    %edx,%eax
    198b:	29 c1                	sub    %eax,%ecx
    198d:	89 ca                	mov    %ecx,%edx
    198f:	83 fa 01             	cmp    $0x1,%edx
    1992:	75 19                	jne    19ad <concreate+0x8d>
      link("C0", file);
    1994:	83 ec 08             	sub    $0x8,%esp
    1997:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    199a:	50                   	push   %eax
    199b:	68 ba 4c 00 00       	push   $0x4cba
    19a0:	e8 86 25 00 00       	call   3f2b <link>
    19a5:	83 c4 10             	add    $0x10,%esp
    19a8:	e9 87 00 00 00       	jmp    1a34 <concreate+0x114>
    } else if(pid == 0 && (i % 5) == 1){
    19ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    19b1:	75 3b                	jne    19ee <concreate+0xce>
    19b3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    19b6:	ba 67 66 66 66       	mov    $0x66666667,%edx
    19bb:	89 c8                	mov    %ecx,%eax
    19bd:	f7 ea                	imul   %edx
    19bf:	d1 fa                	sar    %edx
    19c1:	89 c8                	mov    %ecx,%eax
    19c3:	c1 f8 1f             	sar    $0x1f,%eax
    19c6:	29 c2                	sub    %eax,%edx
    19c8:	89 d0                	mov    %edx,%eax
    19ca:	c1 e0 02             	shl    $0x2,%eax
    19cd:	01 d0                	add    %edx,%eax
    19cf:	29 c1                	sub    %eax,%ecx
    19d1:	89 ca                	mov    %ecx,%edx
    19d3:	83 fa 01             	cmp    $0x1,%edx
    19d6:	75 16                	jne    19ee <concreate+0xce>
      link("C0", file);
    19d8:	83 ec 08             	sub    $0x8,%esp
    19db:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19de:	50                   	push   %eax
    19df:	68 ba 4c 00 00       	push   $0x4cba
    19e4:	e8 42 25 00 00       	call   3f2b <link>
    19e9:	83 c4 10             	add    $0x10,%esp
    19ec:	eb 46                	jmp    1a34 <concreate+0x114>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    19ee:	83 ec 08             	sub    $0x8,%esp
    19f1:	68 02 02 00 00       	push   $0x202
    19f6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19f9:	50                   	push   %eax
    19fa:	e8 0c 25 00 00       	call   3f0b <open>
    19ff:	83 c4 10             	add    $0x10,%esp
    1a02:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(fd < 0){
    1a05:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1a09:	79 1b                	jns    1a26 <concreate+0x106>
        printf(1, "concreate create %s failed\n", file);
    1a0b:	83 ec 04             	sub    $0x4,%esp
    1a0e:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1a11:	50                   	push   %eax
    1a12:	68 bd 4c 00 00       	push   $0x4cbd
    1a17:	6a 01                	push   $0x1
    1a19:	e8 20 26 00 00       	call   403e <printf>
    1a1e:	83 c4 10             	add    $0x10,%esp
        exit();
    1a21:	e8 a5 24 00 00       	call   3ecb <exit>
      }
      close(fd);
    1a26:	83 ec 0c             	sub    $0xc,%esp
    1a29:	ff 75 e8             	pushl  -0x18(%ebp)
    1a2c:	e8 c2 24 00 00       	call   3ef3 <close>
    1a31:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    1a34:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a38:	75 05                	jne    1a3f <concreate+0x11f>
      exit();
    1a3a:	e8 8c 24 00 00       	call   3ecb <exit>
    else
      wait();
    1a3f:	e8 8f 24 00 00       	call   3ed3 <wait>
  for(i = 0; i < 40; i++){
    1a44:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1a48:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1a4c:	0f 8e fa fe ff ff    	jle    194c <concreate+0x2c>
  }

  memset(fa, 0, sizeof(fa));
    1a52:	83 ec 04             	sub    $0x4,%esp
    1a55:	6a 28                	push   $0x28
    1a57:	6a 00                	push   $0x0
    1a59:	8d 45 bd             	lea    -0x43(%ebp),%eax
    1a5c:	50                   	push   %eax
    1a5d:	e8 ce 22 00 00       	call   3d30 <memset>
    1a62:	83 c4 10             	add    $0x10,%esp
  fd = open(".", 0);
    1a65:	83 ec 08             	sub    $0x8,%esp
    1a68:	6a 00                	push   $0x0
    1a6a:	68 7f 4c 00 00       	push   $0x4c7f
    1a6f:	e8 97 24 00 00       	call   3f0b <open>
    1a74:	83 c4 10             	add    $0x10,%esp
    1a77:	89 45 e8             	mov    %eax,-0x18(%ebp)
  n = 0;
    1a7a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    1a81:	e9 93 00 00 00       	jmp    1b19 <concreate+0x1f9>
    if(de.inum == 0)
    1a86:	0f b7 45 ac          	movzwl -0x54(%ebp),%eax
    1a8a:	66 85 c0             	test   %ax,%ax
    1a8d:	75 05                	jne    1a94 <concreate+0x174>
      continue;
    1a8f:	e9 85 00 00 00       	jmp    1b19 <concreate+0x1f9>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1a94:	0f b6 45 ae          	movzbl -0x52(%ebp),%eax
    1a98:	3c 43                	cmp    $0x43,%al
    1a9a:	75 7d                	jne    1b19 <concreate+0x1f9>
    1a9c:	0f b6 45 b0          	movzbl -0x50(%ebp),%eax
    1aa0:	84 c0                	test   %al,%al
    1aa2:	75 75                	jne    1b19 <concreate+0x1f9>
      i = de.name[1] - '0';
    1aa4:	0f b6 45 af          	movzbl -0x51(%ebp),%eax
    1aa8:	0f be c0             	movsbl %al,%eax
    1aab:	83 e8 30             	sub    $0x30,%eax
    1aae:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(i < 0 || i >= sizeof(fa)){
    1ab1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1ab5:	78 08                	js     1abf <concreate+0x19f>
    1ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aba:	83 f8 27             	cmp    $0x27,%eax
    1abd:	76 1e                	jbe    1add <concreate+0x1bd>
        printf(1, "concreate weird file %s\n", de.name);
    1abf:	83 ec 04             	sub    $0x4,%esp
    1ac2:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1ac5:	83 c0 02             	add    $0x2,%eax
    1ac8:	50                   	push   %eax
    1ac9:	68 d9 4c 00 00       	push   $0x4cd9
    1ace:	6a 01                	push   $0x1
    1ad0:	e8 69 25 00 00       	call   403e <printf>
    1ad5:	83 c4 10             	add    $0x10,%esp
        exit();
    1ad8:	e8 ee 23 00 00       	call   3ecb <exit>
      }
      if(fa[i]){
    1add:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ae3:	01 d0                	add    %edx,%eax
    1ae5:	0f b6 00             	movzbl (%eax),%eax
    1ae8:	84 c0                	test   %al,%al
    1aea:	74 1e                	je     1b0a <concreate+0x1ea>
        printf(1, "concreate duplicate file %s\n", de.name);
    1aec:	83 ec 04             	sub    $0x4,%esp
    1aef:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1af2:	83 c0 02             	add    $0x2,%eax
    1af5:	50                   	push   %eax
    1af6:	68 f2 4c 00 00       	push   $0x4cf2
    1afb:	6a 01                	push   $0x1
    1afd:	e8 3c 25 00 00       	call   403e <printf>
    1b02:	83 c4 10             	add    $0x10,%esp
        exit();
    1b05:	e8 c1 23 00 00       	call   3ecb <exit>
      }
      fa[i] = 1;
    1b0a:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b10:	01 d0                	add    %edx,%eax
    1b12:	c6 00 01             	movb   $0x1,(%eax)
      n++;
    1b15:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    1b19:	83 ec 04             	sub    $0x4,%esp
    1b1c:	6a 10                	push   $0x10
    1b1e:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1b21:	50                   	push   %eax
    1b22:	ff 75 e8             	pushl  -0x18(%ebp)
    1b25:	e8 b9 23 00 00       	call   3ee3 <read>
    1b2a:	83 c4 10             	add    $0x10,%esp
    1b2d:	85 c0                	test   %eax,%eax
    1b2f:	0f 8f 51 ff ff ff    	jg     1a86 <concreate+0x166>
    }
  }
  close(fd);
    1b35:	83 ec 0c             	sub    $0xc,%esp
    1b38:	ff 75 e8             	pushl  -0x18(%ebp)
    1b3b:	e8 b3 23 00 00       	call   3ef3 <close>
    1b40:	83 c4 10             	add    $0x10,%esp

  if(n != 40){
    1b43:	83 7d f0 28          	cmpl   $0x28,-0x10(%ebp)
    1b47:	74 17                	je     1b60 <concreate+0x240>
    printf(1, "concreate not enough files in directory listing\n");
    1b49:	83 ec 08             	sub    $0x8,%esp
    1b4c:	68 10 4d 00 00       	push   $0x4d10
    1b51:	6a 01                	push   $0x1
    1b53:	e8 e6 24 00 00       	call   403e <printf>
    1b58:	83 c4 10             	add    $0x10,%esp
    exit();
    1b5b:	e8 6b 23 00 00       	call   3ecb <exit>
  }

  for(i = 0; i < 40; i++){
    1b60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1b67:	e9 45 01 00 00       	jmp    1cb1 <concreate+0x391>
    file[1] = '0' + i;
    1b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b6f:	83 c0 30             	add    $0x30,%eax
    1b72:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    1b75:	e8 49 23 00 00       	call   3ec3 <fork>
    1b7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    1b7d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b81:	79 17                	jns    1b9a <concreate+0x27a>
      printf(1, "fork failed\n");
    1b83:	83 ec 08             	sub    $0x8,%esp
    1b86:	68 95 44 00 00       	push   $0x4495
    1b8b:	6a 01                	push   $0x1
    1b8d:	e8 ac 24 00 00       	call   403e <printf>
    1b92:	83 c4 10             	add    $0x10,%esp
      exit();
    1b95:	e8 31 23 00 00       	call   3ecb <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    1b9a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1b9d:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1ba2:	89 c8                	mov    %ecx,%eax
    1ba4:	f7 ea                	imul   %edx
    1ba6:	89 c8                	mov    %ecx,%eax
    1ba8:	c1 f8 1f             	sar    $0x1f,%eax
    1bab:	29 c2                	sub    %eax,%edx
    1bad:	89 d0                	mov    %edx,%eax
    1baf:	89 c2                	mov    %eax,%edx
    1bb1:	01 d2                	add    %edx,%edx
    1bb3:	01 c2                	add    %eax,%edx
    1bb5:	89 c8                	mov    %ecx,%eax
    1bb7:	29 d0                	sub    %edx,%eax
    1bb9:	85 c0                	test   %eax,%eax
    1bbb:	75 06                	jne    1bc3 <concreate+0x2a3>
    1bbd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1bc1:	74 28                	je     1beb <concreate+0x2cb>
       ((i % 3) == 1 && pid != 0)){
    1bc3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1bc6:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1bcb:	89 c8                	mov    %ecx,%eax
    1bcd:	f7 ea                	imul   %edx
    1bcf:	89 c8                	mov    %ecx,%eax
    1bd1:	c1 f8 1f             	sar    $0x1f,%eax
    1bd4:	29 c2                	sub    %eax,%edx
    1bd6:	89 d0                	mov    %edx,%eax
    1bd8:	01 c0                	add    %eax,%eax
    1bda:	01 d0                	add    %edx,%eax
    1bdc:	29 c1                	sub    %eax,%ecx
    1bde:	89 ca                	mov    %ecx,%edx
    if(((i % 3) == 0 && pid == 0) ||
    1be0:	83 fa 01             	cmp    $0x1,%edx
    1be3:	75 7c                	jne    1c61 <concreate+0x341>
       ((i % 3) == 1 && pid != 0)){
    1be5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1be9:	74 76                	je     1c61 <concreate+0x341>
      close(open(file, 0));
    1beb:	83 ec 08             	sub    $0x8,%esp
    1bee:	6a 00                	push   $0x0
    1bf0:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1bf3:	50                   	push   %eax
    1bf4:	e8 12 23 00 00       	call   3f0b <open>
    1bf9:	83 c4 10             	add    $0x10,%esp
    1bfc:	83 ec 0c             	sub    $0xc,%esp
    1bff:	50                   	push   %eax
    1c00:	e8 ee 22 00 00       	call   3ef3 <close>
    1c05:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1c08:	83 ec 08             	sub    $0x8,%esp
    1c0b:	6a 00                	push   $0x0
    1c0d:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c10:	50                   	push   %eax
    1c11:	e8 f5 22 00 00       	call   3f0b <open>
    1c16:	83 c4 10             	add    $0x10,%esp
    1c19:	83 ec 0c             	sub    $0xc,%esp
    1c1c:	50                   	push   %eax
    1c1d:	e8 d1 22 00 00       	call   3ef3 <close>
    1c22:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1c25:	83 ec 08             	sub    $0x8,%esp
    1c28:	6a 00                	push   $0x0
    1c2a:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c2d:	50                   	push   %eax
    1c2e:	e8 d8 22 00 00       	call   3f0b <open>
    1c33:	83 c4 10             	add    $0x10,%esp
    1c36:	83 ec 0c             	sub    $0xc,%esp
    1c39:	50                   	push   %eax
    1c3a:	e8 b4 22 00 00       	call   3ef3 <close>
    1c3f:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1c42:	83 ec 08             	sub    $0x8,%esp
    1c45:	6a 00                	push   $0x0
    1c47:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c4a:	50                   	push   %eax
    1c4b:	e8 bb 22 00 00       	call   3f0b <open>
    1c50:	83 c4 10             	add    $0x10,%esp
    1c53:	83 ec 0c             	sub    $0xc,%esp
    1c56:	50                   	push   %eax
    1c57:	e8 97 22 00 00       	call   3ef3 <close>
    1c5c:	83 c4 10             	add    $0x10,%esp
    1c5f:	eb 3c                	jmp    1c9d <concreate+0x37d>
    } else {
      unlink(file);
    1c61:	83 ec 0c             	sub    $0xc,%esp
    1c64:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c67:	50                   	push   %eax
    1c68:	e8 ae 22 00 00       	call   3f1b <unlink>
    1c6d:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1c70:	83 ec 0c             	sub    $0xc,%esp
    1c73:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c76:	50                   	push   %eax
    1c77:	e8 9f 22 00 00       	call   3f1b <unlink>
    1c7c:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1c7f:	83 ec 0c             	sub    $0xc,%esp
    1c82:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c85:	50                   	push   %eax
    1c86:	e8 90 22 00 00       	call   3f1b <unlink>
    1c8b:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1c8e:	83 ec 0c             	sub    $0xc,%esp
    1c91:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c94:	50                   	push   %eax
    1c95:	e8 81 22 00 00       	call   3f1b <unlink>
    1c9a:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    1c9d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1ca1:	75 05                	jne    1ca8 <concreate+0x388>
      exit();
    1ca3:	e8 23 22 00 00       	call   3ecb <exit>
    else
      wait();
    1ca8:	e8 26 22 00 00       	call   3ed3 <wait>
  for(i = 0; i < 40; i++){
    1cad:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1cb1:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1cb5:	0f 8e b1 fe ff ff    	jle    1b6c <concreate+0x24c>
  }

  printf(1, "concreate ok\n");
    1cbb:	83 ec 08             	sub    $0x8,%esp
    1cbe:	68 41 4d 00 00       	push   $0x4d41
    1cc3:	6a 01                	push   $0x1
    1cc5:	e8 74 23 00 00       	call   403e <printf>
    1cca:	83 c4 10             	add    $0x10,%esp
}
    1ccd:	90                   	nop
    1cce:	c9                   	leave  
    1ccf:	c3                   	ret    

00001cd0 <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1cd0:	55                   	push   %ebp
    1cd1:	89 e5                	mov    %esp,%ebp
    1cd3:	83 ec 18             	sub    $0x18,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1cd6:	83 ec 08             	sub    $0x8,%esp
    1cd9:	68 4f 4d 00 00       	push   $0x4d4f
    1cde:	6a 01                	push   $0x1
    1ce0:	e8 59 23 00 00       	call   403e <printf>
    1ce5:	83 c4 10             	add    $0x10,%esp

  unlink("x");
    1ce8:	83 ec 0c             	sub    $0xc,%esp
    1ceb:	68 cb 48 00 00       	push   $0x48cb
    1cf0:	e8 26 22 00 00       	call   3f1b <unlink>
    1cf5:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    1cf8:	e8 c6 21 00 00       	call   3ec3 <fork>
    1cfd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid < 0){
    1d00:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d04:	79 17                	jns    1d1d <linkunlink+0x4d>
    printf(1, "fork failed\n");
    1d06:	83 ec 08             	sub    $0x8,%esp
    1d09:	68 95 44 00 00       	push   $0x4495
    1d0e:	6a 01                	push   $0x1
    1d10:	e8 29 23 00 00       	call   403e <printf>
    1d15:	83 c4 10             	add    $0x10,%esp
    exit();
    1d18:	e8 ae 21 00 00       	call   3ecb <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    1d1d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d21:	74 07                	je     1d2a <linkunlink+0x5a>
    1d23:	b8 01 00 00 00       	mov    $0x1,%eax
    1d28:	eb 05                	jmp    1d2f <linkunlink+0x5f>
    1d2a:	b8 61 00 00 00       	mov    $0x61,%eax
    1d2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 100; i++){
    1d32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1d39:	e9 9a 00 00 00       	jmp    1dd8 <linkunlink+0x108>
    x = x * 1103515245 + 12345;
    1d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d41:	69 c0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%eax
    1d47:	05 39 30 00 00       	add    $0x3039,%eax
    1d4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((x % 3) == 0){
    1d4f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1d52:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1d57:	89 c8                	mov    %ecx,%eax
    1d59:	f7 e2                	mul    %edx
    1d5b:	89 d0                	mov    %edx,%eax
    1d5d:	d1 e8                	shr    %eax
    1d5f:	89 c2                	mov    %eax,%edx
    1d61:	01 d2                	add    %edx,%edx
    1d63:	01 c2                	add    %eax,%edx
    1d65:	89 c8                	mov    %ecx,%eax
    1d67:	29 d0                	sub    %edx,%eax
    1d69:	85 c0                	test   %eax,%eax
    1d6b:	75 23                	jne    1d90 <linkunlink+0xc0>
      close(open("x", O_RDWR | O_CREATE));
    1d6d:	83 ec 08             	sub    $0x8,%esp
    1d70:	68 02 02 00 00       	push   $0x202
    1d75:	68 cb 48 00 00       	push   $0x48cb
    1d7a:	e8 8c 21 00 00       	call   3f0b <open>
    1d7f:	83 c4 10             	add    $0x10,%esp
    1d82:	83 ec 0c             	sub    $0xc,%esp
    1d85:	50                   	push   %eax
    1d86:	e8 68 21 00 00       	call   3ef3 <close>
    1d8b:	83 c4 10             	add    $0x10,%esp
    1d8e:	eb 44                	jmp    1dd4 <linkunlink+0x104>
    } else if((x % 3) == 1){
    1d90:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1d93:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1d98:	89 c8                	mov    %ecx,%eax
    1d9a:	f7 e2                	mul    %edx
    1d9c:	d1 ea                	shr    %edx
    1d9e:	89 d0                	mov    %edx,%eax
    1da0:	01 c0                	add    %eax,%eax
    1da2:	01 d0                	add    %edx,%eax
    1da4:	29 c1                	sub    %eax,%ecx
    1da6:	89 ca                	mov    %ecx,%edx
    1da8:	83 fa 01             	cmp    $0x1,%edx
    1dab:	75 17                	jne    1dc4 <linkunlink+0xf4>
      link("cat", "x");
    1dad:	83 ec 08             	sub    $0x8,%esp
    1db0:	68 cb 48 00 00       	push   $0x48cb
    1db5:	68 60 4d 00 00       	push   $0x4d60
    1dba:	e8 6c 21 00 00       	call   3f2b <link>
    1dbf:	83 c4 10             	add    $0x10,%esp
    1dc2:	eb 10                	jmp    1dd4 <linkunlink+0x104>
    } else {
      unlink("x");
    1dc4:	83 ec 0c             	sub    $0xc,%esp
    1dc7:	68 cb 48 00 00       	push   $0x48cb
    1dcc:	e8 4a 21 00 00       	call   3f1b <unlink>
    1dd1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1dd4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1dd8:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    1ddc:	0f 8e 5c ff ff ff    	jle    1d3e <linkunlink+0x6e>
    }
  }

  if(pid)
    1de2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1de6:	74 07                	je     1def <linkunlink+0x11f>
    wait();
    1de8:	e8 e6 20 00 00       	call   3ed3 <wait>
    1ded:	eb 05                	jmp    1df4 <linkunlink+0x124>
  else 
    exit();
    1def:	e8 d7 20 00 00       	call   3ecb <exit>

  printf(1, "linkunlink ok\n");
    1df4:	83 ec 08             	sub    $0x8,%esp
    1df7:	68 64 4d 00 00       	push   $0x4d64
    1dfc:	6a 01                	push   $0x1
    1dfe:	e8 3b 22 00 00       	call   403e <printf>
    1e03:	83 c4 10             	add    $0x10,%esp
}
    1e06:	90                   	nop
    1e07:	c9                   	leave  
    1e08:	c3                   	ret    

00001e09 <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    1e09:	55                   	push   %ebp
    1e0a:	89 e5                	mov    %esp,%ebp
    1e0c:	83 ec 28             	sub    $0x28,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1e0f:	83 ec 08             	sub    $0x8,%esp
    1e12:	68 73 4d 00 00       	push   $0x4d73
    1e17:	6a 01                	push   $0x1
    1e19:	e8 20 22 00 00       	call   403e <printf>
    1e1e:	83 c4 10             	add    $0x10,%esp
  unlink("bd");
    1e21:	83 ec 0c             	sub    $0xc,%esp
    1e24:	68 80 4d 00 00       	push   $0x4d80
    1e29:	e8 ed 20 00 00       	call   3f1b <unlink>
    1e2e:	83 c4 10             	add    $0x10,%esp

  fd = open("bd", O_CREATE);
    1e31:	83 ec 08             	sub    $0x8,%esp
    1e34:	68 00 02 00 00       	push   $0x200
    1e39:	68 80 4d 00 00       	push   $0x4d80
    1e3e:	e8 c8 20 00 00       	call   3f0b <open>
    1e43:	83 c4 10             	add    $0x10,%esp
    1e46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    1e49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1e4d:	79 17                	jns    1e66 <bigdir+0x5d>
    printf(1, "bigdir create failed\n");
    1e4f:	83 ec 08             	sub    $0x8,%esp
    1e52:	68 83 4d 00 00       	push   $0x4d83
    1e57:	6a 01                	push   $0x1
    1e59:	e8 e0 21 00 00       	call   403e <printf>
    1e5e:	83 c4 10             	add    $0x10,%esp
    exit();
    1e61:	e8 65 20 00 00       	call   3ecb <exit>
  }
  close(fd);
    1e66:	83 ec 0c             	sub    $0xc,%esp
    1e69:	ff 75 f0             	pushl  -0x10(%ebp)
    1e6c:	e8 82 20 00 00       	call   3ef3 <close>
    1e71:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 500; i++){
    1e74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1e7b:	eb 63                	jmp    1ee0 <bigdir+0xd7>
    name[0] = 'x';
    1e7d:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e84:	8d 50 3f             	lea    0x3f(%eax),%edx
    1e87:	85 c0                	test   %eax,%eax
    1e89:	0f 48 c2             	cmovs  %edx,%eax
    1e8c:	c1 f8 06             	sar    $0x6,%eax
    1e8f:	83 c0 30             	add    $0x30,%eax
    1e92:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e98:	99                   	cltd   
    1e99:	c1 ea 1a             	shr    $0x1a,%edx
    1e9c:	01 d0                	add    %edx,%eax
    1e9e:	83 e0 3f             	and    $0x3f,%eax
    1ea1:	29 d0                	sub    %edx,%eax
    1ea3:	83 c0 30             	add    $0x30,%eax
    1ea6:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1ea9:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(link("bd", name) != 0){
    1ead:	83 ec 08             	sub    $0x8,%esp
    1eb0:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1eb3:	50                   	push   %eax
    1eb4:	68 80 4d 00 00       	push   $0x4d80
    1eb9:	e8 6d 20 00 00       	call   3f2b <link>
    1ebe:	83 c4 10             	add    $0x10,%esp
    1ec1:	85 c0                	test   %eax,%eax
    1ec3:	74 17                	je     1edc <bigdir+0xd3>
      printf(1, "bigdir link failed\n");
    1ec5:	83 ec 08             	sub    $0x8,%esp
    1ec8:	68 99 4d 00 00       	push   $0x4d99
    1ecd:	6a 01                	push   $0x1
    1ecf:	e8 6a 21 00 00       	call   403e <printf>
    1ed4:	83 c4 10             	add    $0x10,%esp
      exit();
    1ed7:	e8 ef 1f 00 00       	call   3ecb <exit>
  for(i = 0; i < 500; i++){
    1edc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1ee0:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1ee7:	7e 94                	jle    1e7d <bigdir+0x74>
    }
  }

  unlink("bd");
    1ee9:	83 ec 0c             	sub    $0xc,%esp
    1eec:	68 80 4d 00 00       	push   $0x4d80
    1ef1:	e8 25 20 00 00       	call   3f1b <unlink>
    1ef6:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 500; i++){
    1ef9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1f00:	eb 5e                	jmp    1f60 <bigdir+0x157>
    name[0] = 'x';
    1f02:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f09:	8d 50 3f             	lea    0x3f(%eax),%edx
    1f0c:	85 c0                	test   %eax,%eax
    1f0e:	0f 48 c2             	cmovs  %edx,%eax
    1f11:	c1 f8 06             	sar    $0x6,%eax
    1f14:	83 c0 30             	add    $0x30,%eax
    1f17:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f1d:	99                   	cltd   
    1f1e:	c1 ea 1a             	shr    $0x1a,%edx
    1f21:	01 d0                	add    %edx,%eax
    1f23:	83 e0 3f             	and    $0x3f,%eax
    1f26:	29 d0                	sub    %edx,%eax
    1f28:	83 c0 30             	add    $0x30,%eax
    1f2b:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1f2e:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(unlink(name) != 0){
    1f32:	83 ec 0c             	sub    $0xc,%esp
    1f35:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1f38:	50                   	push   %eax
    1f39:	e8 dd 1f 00 00       	call   3f1b <unlink>
    1f3e:	83 c4 10             	add    $0x10,%esp
    1f41:	85 c0                	test   %eax,%eax
    1f43:	74 17                	je     1f5c <bigdir+0x153>
      printf(1, "bigdir unlink failed");
    1f45:	83 ec 08             	sub    $0x8,%esp
    1f48:	68 ad 4d 00 00       	push   $0x4dad
    1f4d:	6a 01                	push   $0x1
    1f4f:	e8 ea 20 00 00       	call   403e <printf>
    1f54:	83 c4 10             	add    $0x10,%esp
      exit();
    1f57:	e8 6f 1f 00 00       	call   3ecb <exit>
  for(i = 0; i < 500; i++){
    1f5c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1f60:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1f67:	7e 99                	jle    1f02 <bigdir+0xf9>
    }
  }

  printf(1, "bigdir ok\n");
    1f69:	83 ec 08             	sub    $0x8,%esp
    1f6c:	68 c2 4d 00 00       	push   $0x4dc2
    1f71:	6a 01                	push   $0x1
    1f73:	e8 c6 20 00 00       	call   403e <printf>
    1f78:	83 c4 10             	add    $0x10,%esp
}
    1f7b:	90                   	nop
    1f7c:	c9                   	leave  
    1f7d:	c3                   	ret    

00001f7e <subdir>:

void
subdir(void)
{
    1f7e:	55                   	push   %ebp
    1f7f:	89 e5                	mov    %esp,%ebp
    1f81:	83 ec 18             	sub    $0x18,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1f84:	83 ec 08             	sub    $0x8,%esp
    1f87:	68 cd 4d 00 00       	push   $0x4dcd
    1f8c:	6a 01                	push   $0x1
    1f8e:	e8 ab 20 00 00       	call   403e <printf>
    1f93:	83 c4 10             	add    $0x10,%esp

  unlink("ff");
    1f96:	83 ec 0c             	sub    $0xc,%esp
    1f99:	68 da 4d 00 00       	push   $0x4dda
    1f9e:	e8 78 1f 00 00       	call   3f1b <unlink>
    1fa3:	83 c4 10             	add    $0x10,%esp
  if(mkdir("dd") != 0){
    1fa6:	83 ec 0c             	sub    $0xc,%esp
    1fa9:	68 dd 4d 00 00       	push   $0x4ddd
    1fae:	e8 80 1f 00 00       	call   3f33 <mkdir>
    1fb3:	83 c4 10             	add    $0x10,%esp
    1fb6:	85 c0                	test   %eax,%eax
    1fb8:	74 17                	je     1fd1 <subdir+0x53>
    printf(1, "subdir mkdir dd failed\n");
    1fba:	83 ec 08             	sub    $0x8,%esp
    1fbd:	68 e0 4d 00 00       	push   $0x4de0
    1fc2:	6a 01                	push   $0x1
    1fc4:	e8 75 20 00 00       	call   403e <printf>
    1fc9:	83 c4 10             	add    $0x10,%esp
    exit();
    1fcc:	e8 fa 1e 00 00       	call   3ecb <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1fd1:	83 ec 08             	sub    $0x8,%esp
    1fd4:	68 02 02 00 00       	push   $0x202
    1fd9:	68 f8 4d 00 00       	push   $0x4df8
    1fde:	e8 28 1f 00 00       	call   3f0b <open>
    1fe3:	83 c4 10             	add    $0x10,%esp
    1fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1fe9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1fed:	79 17                	jns    2006 <subdir+0x88>
    printf(1, "create dd/ff failed\n");
    1fef:	83 ec 08             	sub    $0x8,%esp
    1ff2:	68 fe 4d 00 00       	push   $0x4dfe
    1ff7:	6a 01                	push   $0x1
    1ff9:	e8 40 20 00 00       	call   403e <printf>
    1ffe:	83 c4 10             	add    $0x10,%esp
    exit();
    2001:	e8 c5 1e 00 00       	call   3ecb <exit>
  }
  write(fd, "ff", 2);
    2006:	83 ec 04             	sub    $0x4,%esp
    2009:	6a 02                	push   $0x2
    200b:	68 da 4d 00 00       	push   $0x4dda
    2010:	ff 75 f4             	pushl  -0xc(%ebp)
    2013:	e8 d3 1e 00 00       	call   3eeb <write>
    2018:	83 c4 10             	add    $0x10,%esp
  close(fd);
    201b:	83 ec 0c             	sub    $0xc,%esp
    201e:	ff 75 f4             	pushl  -0xc(%ebp)
    2021:	e8 cd 1e 00 00       	call   3ef3 <close>
    2026:	83 c4 10             	add    $0x10,%esp
  
  if(unlink("dd") >= 0){
    2029:	83 ec 0c             	sub    $0xc,%esp
    202c:	68 dd 4d 00 00       	push   $0x4ddd
    2031:	e8 e5 1e 00 00       	call   3f1b <unlink>
    2036:	83 c4 10             	add    $0x10,%esp
    2039:	85 c0                	test   %eax,%eax
    203b:	78 17                	js     2054 <subdir+0xd6>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    203d:	83 ec 08             	sub    $0x8,%esp
    2040:	68 14 4e 00 00       	push   $0x4e14
    2045:	6a 01                	push   $0x1
    2047:	e8 f2 1f 00 00       	call   403e <printf>
    204c:	83 c4 10             	add    $0x10,%esp
    exit();
    204f:	e8 77 1e 00 00       	call   3ecb <exit>
  }

  if(mkdir("/dd/dd") != 0){
    2054:	83 ec 0c             	sub    $0xc,%esp
    2057:	68 3a 4e 00 00       	push   $0x4e3a
    205c:	e8 d2 1e 00 00       	call   3f33 <mkdir>
    2061:	83 c4 10             	add    $0x10,%esp
    2064:	85 c0                	test   %eax,%eax
    2066:	74 17                	je     207f <subdir+0x101>
    printf(1, "subdir mkdir dd/dd failed\n");
    2068:	83 ec 08             	sub    $0x8,%esp
    206b:	68 41 4e 00 00       	push   $0x4e41
    2070:	6a 01                	push   $0x1
    2072:	e8 c7 1f 00 00       	call   403e <printf>
    2077:	83 c4 10             	add    $0x10,%esp
    exit();
    207a:	e8 4c 1e 00 00       	call   3ecb <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    207f:	83 ec 08             	sub    $0x8,%esp
    2082:	68 02 02 00 00       	push   $0x202
    2087:	68 5c 4e 00 00       	push   $0x4e5c
    208c:	e8 7a 1e 00 00       	call   3f0b <open>
    2091:	83 c4 10             	add    $0x10,%esp
    2094:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2097:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    209b:	79 17                	jns    20b4 <subdir+0x136>
    printf(1, "create dd/dd/ff failed\n");
    209d:	83 ec 08             	sub    $0x8,%esp
    20a0:	68 65 4e 00 00       	push   $0x4e65
    20a5:	6a 01                	push   $0x1
    20a7:	e8 92 1f 00 00       	call   403e <printf>
    20ac:	83 c4 10             	add    $0x10,%esp
    exit();
    20af:	e8 17 1e 00 00       	call   3ecb <exit>
  }
  write(fd, "FF", 2);
    20b4:	83 ec 04             	sub    $0x4,%esp
    20b7:	6a 02                	push   $0x2
    20b9:	68 7d 4e 00 00       	push   $0x4e7d
    20be:	ff 75 f4             	pushl  -0xc(%ebp)
    20c1:	e8 25 1e 00 00       	call   3eeb <write>
    20c6:	83 c4 10             	add    $0x10,%esp
  close(fd);
    20c9:	83 ec 0c             	sub    $0xc,%esp
    20cc:	ff 75 f4             	pushl  -0xc(%ebp)
    20cf:	e8 1f 1e 00 00       	call   3ef3 <close>
    20d4:	83 c4 10             	add    $0x10,%esp

  fd = open("dd/dd/../ff", 0);
    20d7:	83 ec 08             	sub    $0x8,%esp
    20da:	6a 00                	push   $0x0
    20dc:	68 80 4e 00 00       	push   $0x4e80
    20e1:	e8 25 1e 00 00       	call   3f0b <open>
    20e6:	83 c4 10             	add    $0x10,%esp
    20e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    20ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    20f0:	79 17                	jns    2109 <subdir+0x18b>
    printf(1, "open dd/dd/../ff failed\n");
    20f2:	83 ec 08             	sub    $0x8,%esp
    20f5:	68 8c 4e 00 00       	push   $0x4e8c
    20fa:	6a 01                	push   $0x1
    20fc:	e8 3d 1f 00 00       	call   403e <printf>
    2101:	83 c4 10             	add    $0x10,%esp
    exit();
    2104:	e8 c2 1d 00 00       	call   3ecb <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    2109:	83 ec 04             	sub    $0x4,%esp
    210c:	68 00 20 00 00       	push   $0x2000
    2111:	68 a0 8a 00 00       	push   $0x8aa0
    2116:	ff 75 f4             	pushl  -0xc(%ebp)
    2119:	e8 c5 1d 00 00       	call   3ee3 <read>
    211e:	83 c4 10             	add    $0x10,%esp
    2121:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(cc != 2 || buf[0] != 'f'){
    2124:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
    2128:	75 0b                	jne    2135 <subdir+0x1b7>
    212a:	0f b6 05 a0 8a 00 00 	movzbl 0x8aa0,%eax
    2131:	3c 66                	cmp    $0x66,%al
    2133:	74 17                	je     214c <subdir+0x1ce>
    printf(1, "dd/dd/../ff wrong content\n");
    2135:	83 ec 08             	sub    $0x8,%esp
    2138:	68 a5 4e 00 00       	push   $0x4ea5
    213d:	6a 01                	push   $0x1
    213f:	e8 fa 1e 00 00       	call   403e <printf>
    2144:	83 c4 10             	add    $0x10,%esp
    exit();
    2147:	e8 7f 1d 00 00       	call   3ecb <exit>
  }
  close(fd);
    214c:	83 ec 0c             	sub    $0xc,%esp
    214f:	ff 75 f4             	pushl  -0xc(%ebp)
    2152:	e8 9c 1d 00 00       	call   3ef3 <close>
    2157:	83 c4 10             	add    $0x10,%esp

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    215a:	83 ec 08             	sub    $0x8,%esp
    215d:	68 c0 4e 00 00       	push   $0x4ec0
    2162:	68 5c 4e 00 00       	push   $0x4e5c
    2167:	e8 bf 1d 00 00       	call   3f2b <link>
    216c:	83 c4 10             	add    $0x10,%esp
    216f:	85 c0                	test   %eax,%eax
    2171:	74 17                	je     218a <subdir+0x20c>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    2173:	83 ec 08             	sub    $0x8,%esp
    2176:	68 cc 4e 00 00       	push   $0x4ecc
    217b:	6a 01                	push   $0x1
    217d:	e8 bc 1e 00 00       	call   403e <printf>
    2182:	83 c4 10             	add    $0x10,%esp
    exit();
    2185:	e8 41 1d 00 00       	call   3ecb <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    218a:	83 ec 0c             	sub    $0xc,%esp
    218d:	68 5c 4e 00 00       	push   $0x4e5c
    2192:	e8 84 1d 00 00       	call   3f1b <unlink>
    2197:	83 c4 10             	add    $0x10,%esp
    219a:	85 c0                	test   %eax,%eax
    219c:	74 17                	je     21b5 <subdir+0x237>
    printf(1, "unlink dd/dd/ff failed\n");
    219e:	83 ec 08             	sub    $0x8,%esp
    21a1:	68 ed 4e 00 00       	push   $0x4eed
    21a6:	6a 01                	push   $0x1
    21a8:	e8 91 1e 00 00       	call   403e <printf>
    21ad:	83 c4 10             	add    $0x10,%esp
    exit();
    21b0:	e8 16 1d 00 00       	call   3ecb <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    21b5:	83 ec 08             	sub    $0x8,%esp
    21b8:	6a 00                	push   $0x0
    21ba:	68 5c 4e 00 00       	push   $0x4e5c
    21bf:	e8 47 1d 00 00       	call   3f0b <open>
    21c4:	83 c4 10             	add    $0x10,%esp
    21c7:	85 c0                	test   %eax,%eax
    21c9:	78 17                	js     21e2 <subdir+0x264>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    21cb:	83 ec 08             	sub    $0x8,%esp
    21ce:	68 08 4f 00 00       	push   $0x4f08
    21d3:	6a 01                	push   $0x1
    21d5:	e8 64 1e 00 00       	call   403e <printf>
    21da:	83 c4 10             	add    $0x10,%esp
    exit();
    21dd:	e8 e9 1c 00 00       	call   3ecb <exit>
  }

  if(chdir("dd") != 0){
    21e2:	83 ec 0c             	sub    $0xc,%esp
    21e5:	68 dd 4d 00 00       	push   $0x4ddd
    21ea:	e8 4c 1d 00 00       	call   3f3b <chdir>
    21ef:	83 c4 10             	add    $0x10,%esp
    21f2:	85 c0                	test   %eax,%eax
    21f4:	74 17                	je     220d <subdir+0x28f>
    printf(1, "chdir dd failed\n");
    21f6:	83 ec 08             	sub    $0x8,%esp
    21f9:	68 2c 4f 00 00       	push   $0x4f2c
    21fe:	6a 01                	push   $0x1
    2200:	e8 39 1e 00 00       	call   403e <printf>
    2205:	83 c4 10             	add    $0x10,%esp
    exit();
    2208:	e8 be 1c 00 00       	call   3ecb <exit>
  }
  if(chdir("dd/../../dd") != 0){
    220d:	83 ec 0c             	sub    $0xc,%esp
    2210:	68 3d 4f 00 00       	push   $0x4f3d
    2215:	e8 21 1d 00 00       	call   3f3b <chdir>
    221a:	83 c4 10             	add    $0x10,%esp
    221d:	85 c0                	test   %eax,%eax
    221f:	74 17                	je     2238 <subdir+0x2ba>
    printf(1, "chdir dd/../../dd failed\n");
    2221:	83 ec 08             	sub    $0x8,%esp
    2224:	68 49 4f 00 00       	push   $0x4f49
    2229:	6a 01                	push   $0x1
    222b:	e8 0e 1e 00 00       	call   403e <printf>
    2230:	83 c4 10             	add    $0x10,%esp
    exit();
    2233:	e8 93 1c 00 00       	call   3ecb <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    2238:	83 ec 0c             	sub    $0xc,%esp
    223b:	68 63 4f 00 00       	push   $0x4f63
    2240:	e8 f6 1c 00 00       	call   3f3b <chdir>
    2245:	83 c4 10             	add    $0x10,%esp
    2248:	85 c0                	test   %eax,%eax
    224a:	74 17                	je     2263 <subdir+0x2e5>
    printf(1, "chdir dd/../../dd failed\n");
    224c:	83 ec 08             	sub    $0x8,%esp
    224f:	68 49 4f 00 00       	push   $0x4f49
    2254:	6a 01                	push   $0x1
    2256:	e8 e3 1d 00 00       	call   403e <printf>
    225b:	83 c4 10             	add    $0x10,%esp
    exit();
    225e:	e8 68 1c 00 00       	call   3ecb <exit>
  }
  if(chdir("./..") != 0){
    2263:	83 ec 0c             	sub    $0xc,%esp
    2266:	68 72 4f 00 00       	push   $0x4f72
    226b:	e8 cb 1c 00 00       	call   3f3b <chdir>
    2270:	83 c4 10             	add    $0x10,%esp
    2273:	85 c0                	test   %eax,%eax
    2275:	74 17                	je     228e <subdir+0x310>
    printf(1, "chdir ./.. failed\n");
    2277:	83 ec 08             	sub    $0x8,%esp
    227a:	68 77 4f 00 00       	push   $0x4f77
    227f:	6a 01                	push   $0x1
    2281:	e8 b8 1d 00 00       	call   403e <printf>
    2286:	83 c4 10             	add    $0x10,%esp
    exit();
    2289:	e8 3d 1c 00 00       	call   3ecb <exit>
  }

  fd = open("dd/dd/ffff", 0);
    228e:	83 ec 08             	sub    $0x8,%esp
    2291:	6a 00                	push   $0x0
    2293:	68 c0 4e 00 00       	push   $0x4ec0
    2298:	e8 6e 1c 00 00       	call   3f0b <open>
    229d:	83 c4 10             	add    $0x10,%esp
    22a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    22a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    22a7:	79 17                	jns    22c0 <subdir+0x342>
    printf(1, "open dd/dd/ffff failed\n");
    22a9:	83 ec 08             	sub    $0x8,%esp
    22ac:	68 8a 4f 00 00       	push   $0x4f8a
    22b1:	6a 01                	push   $0x1
    22b3:	e8 86 1d 00 00       	call   403e <printf>
    22b8:	83 c4 10             	add    $0x10,%esp
    exit();
    22bb:	e8 0b 1c 00 00       	call   3ecb <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    22c0:	83 ec 04             	sub    $0x4,%esp
    22c3:	68 00 20 00 00       	push   $0x2000
    22c8:	68 a0 8a 00 00       	push   $0x8aa0
    22cd:	ff 75 f4             	pushl  -0xc(%ebp)
    22d0:	e8 0e 1c 00 00       	call   3ee3 <read>
    22d5:	83 c4 10             	add    $0x10,%esp
    22d8:	83 f8 02             	cmp    $0x2,%eax
    22db:	74 17                	je     22f4 <subdir+0x376>
    printf(1, "read dd/dd/ffff wrong len\n");
    22dd:	83 ec 08             	sub    $0x8,%esp
    22e0:	68 a2 4f 00 00       	push   $0x4fa2
    22e5:	6a 01                	push   $0x1
    22e7:	e8 52 1d 00 00       	call   403e <printf>
    22ec:	83 c4 10             	add    $0x10,%esp
    exit();
    22ef:	e8 d7 1b 00 00       	call   3ecb <exit>
  }
  close(fd);
    22f4:	83 ec 0c             	sub    $0xc,%esp
    22f7:	ff 75 f4             	pushl  -0xc(%ebp)
    22fa:	e8 f4 1b 00 00       	call   3ef3 <close>
    22ff:	83 c4 10             	add    $0x10,%esp

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2302:	83 ec 08             	sub    $0x8,%esp
    2305:	6a 00                	push   $0x0
    2307:	68 5c 4e 00 00       	push   $0x4e5c
    230c:	e8 fa 1b 00 00       	call   3f0b <open>
    2311:	83 c4 10             	add    $0x10,%esp
    2314:	85 c0                	test   %eax,%eax
    2316:	78 17                	js     232f <subdir+0x3b1>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    2318:	83 ec 08             	sub    $0x8,%esp
    231b:	68 c0 4f 00 00       	push   $0x4fc0
    2320:	6a 01                	push   $0x1
    2322:	e8 17 1d 00 00       	call   403e <printf>
    2327:	83 c4 10             	add    $0x10,%esp
    exit();
    232a:	e8 9c 1b 00 00       	call   3ecb <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    232f:	83 ec 08             	sub    $0x8,%esp
    2332:	68 02 02 00 00       	push   $0x202
    2337:	68 e5 4f 00 00       	push   $0x4fe5
    233c:	e8 ca 1b 00 00       	call   3f0b <open>
    2341:	83 c4 10             	add    $0x10,%esp
    2344:	85 c0                	test   %eax,%eax
    2346:	78 17                	js     235f <subdir+0x3e1>
    printf(1, "create dd/ff/ff succeeded!\n");
    2348:	83 ec 08             	sub    $0x8,%esp
    234b:	68 ee 4f 00 00       	push   $0x4fee
    2350:	6a 01                	push   $0x1
    2352:	e8 e7 1c 00 00       	call   403e <printf>
    2357:	83 c4 10             	add    $0x10,%esp
    exit();
    235a:	e8 6c 1b 00 00       	call   3ecb <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    235f:	83 ec 08             	sub    $0x8,%esp
    2362:	68 02 02 00 00       	push   $0x202
    2367:	68 0a 50 00 00       	push   $0x500a
    236c:	e8 9a 1b 00 00       	call   3f0b <open>
    2371:	83 c4 10             	add    $0x10,%esp
    2374:	85 c0                	test   %eax,%eax
    2376:	78 17                	js     238f <subdir+0x411>
    printf(1, "create dd/xx/ff succeeded!\n");
    2378:	83 ec 08             	sub    $0x8,%esp
    237b:	68 13 50 00 00       	push   $0x5013
    2380:	6a 01                	push   $0x1
    2382:	e8 b7 1c 00 00       	call   403e <printf>
    2387:	83 c4 10             	add    $0x10,%esp
    exit();
    238a:	e8 3c 1b 00 00       	call   3ecb <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    238f:	83 ec 08             	sub    $0x8,%esp
    2392:	68 00 02 00 00       	push   $0x200
    2397:	68 dd 4d 00 00       	push   $0x4ddd
    239c:	e8 6a 1b 00 00       	call   3f0b <open>
    23a1:	83 c4 10             	add    $0x10,%esp
    23a4:	85 c0                	test   %eax,%eax
    23a6:	78 17                	js     23bf <subdir+0x441>
    printf(1, "create dd succeeded!\n");
    23a8:	83 ec 08             	sub    $0x8,%esp
    23ab:	68 2f 50 00 00       	push   $0x502f
    23b0:	6a 01                	push   $0x1
    23b2:	e8 87 1c 00 00       	call   403e <printf>
    23b7:	83 c4 10             	add    $0x10,%esp
    exit();
    23ba:	e8 0c 1b 00 00       	call   3ecb <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    23bf:	83 ec 08             	sub    $0x8,%esp
    23c2:	6a 02                	push   $0x2
    23c4:	68 dd 4d 00 00       	push   $0x4ddd
    23c9:	e8 3d 1b 00 00       	call   3f0b <open>
    23ce:	83 c4 10             	add    $0x10,%esp
    23d1:	85 c0                	test   %eax,%eax
    23d3:	78 17                	js     23ec <subdir+0x46e>
    printf(1, "open dd rdwr succeeded!\n");
    23d5:	83 ec 08             	sub    $0x8,%esp
    23d8:	68 45 50 00 00       	push   $0x5045
    23dd:	6a 01                	push   $0x1
    23df:	e8 5a 1c 00 00       	call   403e <printf>
    23e4:	83 c4 10             	add    $0x10,%esp
    exit();
    23e7:	e8 df 1a 00 00       	call   3ecb <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    23ec:	83 ec 08             	sub    $0x8,%esp
    23ef:	6a 01                	push   $0x1
    23f1:	68 dd 4d 00 00       	push   $0x4ddd
    23f6:	e8 10 1b 00 00       	call   3f0b <open>
    23fb:	83 c4 10             	add    $0x10,%esp
    23fe:	85 c0                	test   %eax,%eax
    2400:	78 17                	js     2419 <subdir+0x49b>
    printf(1, "open dd wronly succeeded!\n");
    2402:	83 ec 08             	sub    $0x8,%esp
    2405:	68 5e 50 00 00       	push   $0x505e
    240a:	6a 01                	push   $0x1
    240c:	e8 2d 1c 00 00       	call   403e <printf>
    2411:	83 c4 10             	add    $0x10,%esp
    exit();
    2414:	e8 b2 1a 00 00       	call   3ecb <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2419:	83 ec 08             	sub    $0x8,%esp
    241c:	68 79 50 00 00       	push   $0x5079
    2421:	68 e5 4f 00 00       	push   $0x4fe5
    2426:	e8 00 1b 00 00       	call   3f2b <link>
    242b:	83 c4 10             	add    $0x10,%esp
    242e:	85 c0                	test   %eax,%eax
    2430:	75 17                	jne    2449 <subdir+0x4cb>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    2432:	83 ec 08             	sub    $0x8,%esp
    2435:	68 84 50 00 00       	push   $0x5084
    243a:	6a 01                	push   $0x1
    243c:	e8 fd 1b 00 00       	call   403e <printf>
    2441:	83 c4 10             	add    $0x10,%esp
    exit();
    2444:	e8 82 1a 00 00       	call   3ecb <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2449:	83 ec 08             	sub    $0x8,%esp
    244c:	68 79 50 00 00       	push   $0x5079
    2451:	68 0a 50 00 00       	push   $0x500a
    2456:	e8 d0 1a 00 00       	call   3f2b <link>
    245b:	83 c4 10             	add    $0x10,%esp
    245e:	85 c0                	test   %eax,%eax
    2460:	75 17                	jne    2479 <subdir+0x4fb>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    2462:	83 ec 08             	sub    $0x8,%esp
    2465:	68 a8 50 00 00       	push   $0x50a8
    246a:	6a 01                	push   $0x1
    246c:	e8 cd 1b 00 00       	call   403e <printf>
    2471:	83 c4 10             	add    $0x10,%esp
    exit();
    2474:	e8 52 1a 00 00       	call   3ecb <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2479:	83 ec 08             	sub    $0x8,%esp
    247c:	68 c0 4e 00 00       	push   $0x4ec0
    2481:	68 f8 4d 00 00       	push   $0x4df8
    2486:	e8 a0 1a 00 00       	call   3f2b <link>
    248b:	83 c4 10             	add    $0x10,%esp
    248e:	85 c0                	test   %eax,%eax
    2490:	75 17                	jne    24a9 <subdir+0x52b>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    2492:	83 ec 08             	sub    $0x8,%esp
    2495:	68 cc 50 00 00       	push   $0x50cc
    249a:	6a 01                	push   $0x1
    249c:	e8 9d 1b 00 00       	call   403e <printf>
    24a1:	83 c4 10             	add    $0x10,%esp
    exit();
    24a4:	e8 22 1a 00 00       	call   3ecb <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    24a9:	83 ec 0c             	sub    $0xc,%esp
    24ac:	68 e5 4f 00 00       	push   $0x4fe5
    24b1:	e8 7d 1a 00 00       	call   3f33 <mkdir>
    24b6:	83 c4 10             	add    $0x10,%esp
    24b9:	85 c0                	test   %eax,%eax
    24bb:	75 17                	jne    24d4 <subdir+0x556>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    24bd:	83 ec 08             	sub    $0x8,%esp
    24c0:	68 ee 50 00 00       	push   $0x50ee
    24c5:	6a 01                	push   $0x1
    24c7:	e8 72 1b 00 00       	call   403e <printf>
    24cc:	83 c4 10             	add    $0x10,%esp
    exit();
    24cf:	e8 f7 19 00 00       	call   3ecb <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    24d4:	83 ec 0c             	sub    $0xc,%esp
    24d7:	68 0a 50 00 00       	push   $0x500a
    24dc:	e8 52 1a 00 00       	call   3f33 <mkdir>
    24e1:	83 c4 10             	add    $0x10,%esp
    24e4:	85 c0                	test   %eax,%eax
    24e6:	75 17                	jne    24ff <subdir+0x581>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    24e8:	83 ec 08             	sub    $0x8,%esp
    24eb:	68 09 51 00 00       	push   $0x5109
    24f0:	6a 01                	push   $0x1
    24f2:	e8 47 1b 00 00       	call   403e <printf>
    24f7:	83 c4 10             	add    $0x10,%esp
    exit();
    24fa:	e8 cc 19 00 00       	call   3ecb <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    24ff:	83 ec 0c             	sub    $0xc,%esp
    2502:	68 c0 4e 00 00       	push   $0x4ec0
    2507:	e8 27 1a 00 00       	call   3f33 <mkdir>
    250c:	83 c4 10             	add    $0x10,%esp
    250f:	85 c0                	test   %eax,%eax
    2511:	75 17                	jne    252a <subdir+0x5ac>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    2513:	83 ec 08             	sub    $0x8,%esp
    2516:	68 24 51 00 00       	push   $0x5124
    251b:	6a 01                	push   $0x1
    251d:	e8 1c 1b 00 00       	call   403e <printf>
    2522:	83 c4 10             	add    $0x10,%esp
    exit();
    2525:	e8 a1 19 00 00       	call   3ecb <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    252a:	83 ec 0c             	sub    $0xc,%esp
    252d:	68 0a 50 00 00       	push   $0x500a
    2532:	e8 e4 19 00 00       	call   3f1b <unlink>
    2537:	83 c4 10             	add    $0x10,%esp
    253a:	85 c0                	test   %eax,%eax
    253c:	75 17                	jne    2555 <subdir+0x5d7>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    253e:	83 ec 08             	sub    $0x8,%esp
    2541:	68 41 51 00 00       	push   $0x5141
    2546:	6a 01                	push   $0x1
    2548:	e8 f1 1a 00 00       	call   403e <printf>
    254d:	83 c4 10             	add    $0x10,%esp
    exit();
    2550:	e8 76 19 00 00       	call   3ecb <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    2555:	83 ec 0c             	sub    $0xc,%esp
    2558:	68 e5 4f 00 00       	push   $0x4fe5
    255d:	e8 b9 19 00 00       	call   3f1b <unlink>
    2562:	83 c4 10             	add    $0x10,%esp
    2565:	85 c0                	test   %eax,%eax
    2567:	75 17                	jne    2580 <subdir+0x602>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    2569:	83 ec 08             	sub    $0x8,%esp
    256c:	68 5d 51 00 00       	push   $0x515d
    2571:	6a 01                	push   $0x1
    2573:	e8 c6 1a 00 00       	call   403e <printf>
    2578:	83 c4 10             	add    $0x10,%esp
    exit();
    257b:	e8 4b 19 00 00       	call   3ecb <exit>
  }
  if(chdir("dd/ff") == 0){
    2580:	83 ec 0c             	sub    $0xc,%esp
    2583:	68 f8 4d 00 00       	push   $0x4df8
    2588:	e8 ae 19 00 00       	call   3f3b <chdir>
    258d:	83 c4 10             	add    $0x10,%esp
    2590:	85 c0                	test   %eax,%eax
    2592:	75 17                	jne    25ab <subdir+0x62d>
    printf(1, "chdir dd/ff succeeded!\n");
    2594:	83 ec 08             	sub    $0x8,%esp
    2597:	68 79 51 00 00       	push   $0x5179
    259c:	6a 01                	push   $0x1
    259e:	e8 9b 1a 00 00       	call   403e <printf>
    25a3:	83 c4 10             	add    $0x10,%esp
    exit();
    25a6:	e8 20 19 00 00       	call   3ecb <exit>
  }
  if(chdir("dd/xx") == 0){
    25ab:	83 ec 0c             	sub    $0xc,%esp
    25ae:	68 91 51 00 00       	push   $0x5191
    25b3:	e8 83 19 00 00       	call   3f3b <chdir>
    25b8:	83 c4 10             	add    $0x10,%esp
    25bb:	85 c0                	test   %eax,%eax
    25bd:	75 17                	jne    25d6 <subdir+0x658>
    printf(1, "chdir dd/xx succeeded!\n");
    25bf:	83 ec 08             	sub    $0x8,%esp
    25c2:	68 97 51 00 00       	push   $0x5197
    25c7:	6a 01                	push   $0x1
    25c9:	e8 70 1a 00 00       	call   403e <printf>
    25ce:	83 c4 10             	add    $0x10,%esp
    exit();
    25d1:	e8 f5 18 00 00       	call   3ecb <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    25d6:	83 ec 0c             	sub    $0xc,%esp
    25d9:	68 c0 4e 00 00       	push   $0x4ec0
    25de:	e8 38 19 00 00       	call   3f1b <unlink>
    25e3:	83 c4 10             	add    $0x10,%esp
    25e6:	85 c0                	test   %eax,%eax
    25e8:	74 17                	je     2601 <subdir+0x683>
    printf(1, "unlink dd/dd/ff failed\n");
    25ea:	83 ec 08             	sub    $0x8,%esp
    25ed:	68 ed 4e 00 00       	push   $0x4eed
    25f2:	6a 01                	push   $0x1
    25f4:	e8 45 1a 00 00       	call   403e <printf>
    25f9:	83 c4 10             	add    $0x10,%esp
    exit();
    25fc:	e8 ca 18 00 00       	call   3ecb <exit>
  }
  if(unlink("dd/ff") != 0){
    2601:	83 ec 0c             	sub    $0xc,%esp
    2604:	68 f8 4d 00 00       	push   $0x4df8
    2609:	e8 0d 19 00 00       	call   3f1b <unlink>
    260e:	83 c4 10             	add    $0x10,%esp
    2611:	85 c0                	test   %eax,%eax
    2613:	74 17                	je     262c <subdir+0x6ae>
    printf(1, "unlink dd/ff failed\n");
    2615:	83 ec 08             	sub    $0x8,%esp
    2618:	68 af 51 00 00       	push   $0x51af
    261d:	6a 01                	push   $0x1
    261f:	e8 1a 1a 00 00       	call   403e <printf>
    2624:	83 c4 10             	add    $0x10,%esp
    exit();
    2627:	e8 9f 18 00 00       	call   3ecb <exit>
  }
  if(unlink("dd") == 0){
    262c:	83 ec 0c             	sub    $0xc,%esp
    262f:	68 dd 4d 00 00       	push   $0x4ddd
    2634:	e8 e2 18 00 00       	call   3f1b <unlink>
    2639:	83 c4 10             	add    $0x10,%esp
    263c:	85 c0                	test   %eax,%eax
    263e:	75 17                	jne    2657 <subdir+0x6d9>
    printf(1, "unlink non-empty dd succeeded!\n");
    2640:	83 ec 08             	sub    $0x8,%esp
    2643:	68 c4 51 00 00       	push   $0x51c4
    2648:	6a 01                	push   $0x1
    264a:	e8 ef 19 00 00       	call   403e <printf>
    264f:	83 c4 10             	add    $0x10,%esp
    exit();
    2652:	e8 74 18 00 00       	call   3ecb <exit>
  }
  if(unlink("dd/dd") < 0){
    2657:	83 ec 0c             	sub    $0xc,%esp
    265a:	68 e4 51 00 00       	push   $0x51e4
    265f:	e8 b7 18 00 00       	call   3f1b <unlink>
    2664:	83 c4 10             	add    $0x10,%esp
    2667:	85 c0                	test   %eax,%eax
    2669:	79 17                	jns    2682 <subdir+0x704>
    printf(1, "unlink dd/dd failed\n");
    266b:	83 ec 08             	sub    $0x8,%esp
    266e:	68 ea 51 00 00       	push   $0x51ea
    2673:	6a 01                	push   $0x1
    2675:	e8 c4 19 00 00       	call   403e <printf>
    267a:	83 c4 10             	add    $0x10,%esp
    exit();
    267d:	e8 49 18 00 00       	call   3ecb <exit>
  }
  if(unlink("dd") < 0){
    2682:	83 ec 0c             	sub    $0xc,%esp
    2685:	68 dd 4d 00 00       	push   $0x4ddd
    268a:	e8 8c 18 00 00       	call   3f1b <unlink>
    268f:	83 c4 10             	add    $0x10,%esp
    2692:	85 c0                	test   %eax,%eax
    2694:	79 17                	jns    26ad <subdir+0x72f>
    printf(1, "unlink dd failed\n");
    2696:	83 ec 08             	sub    $0x8,%esp
    2699:	68 ff 51 00 00       	push   $0x51ff
    269e:	6a 01                	push   $0x1
    26a0:	e8 99 19 00 00       	call   403e <printf>
    26a5:	83 c4 10             	add    $0x10,%esp
    exit();
    26a8:	e8 1e 18 00 00       	call   3ecb <exit>
  }

  printf(1, "subdir ok\n");
    26ad:	83 ec 08             	sub    $0x8,%esp
    26b0:	68 11 52 00 00       	push   $0x5211
    26b5:	6a 01                	push   $0x1
    26b7:	e8 82 19 00 00       	call   403e <printf>
    26bc:	83 c4 10             	add    $0x10,%esp
}
    26bf:	90                   	nop
    26c0:	c9                   	leave  
    26c1:	c3                   	ret    

000026c2 <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    26c2:	55                   	push   %ebp
    26c3:	89 e5                	mov    %esp,%ebp
    26c5:	83 ec 18             	sub    $0x18,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    26c8:	83 ec 08             	sub    $0x8,%esp
    26cb:	68 1c 52 00 00       	push   $0x521c
    26d0:	6a 01                	push   $0x1
    26d2:	e8 67 19 00 00       	call   403e <printf>
    26d7:	83 c4 10             	add    $0x10,%esp

  unlink("bigwrite");
    26da:	83 ec 0c             	sub    $0xc,%esp
    26dd:	68 2b 52 00 00       	push   $0x522b
    26e2:	e8 34 18 00 00       	call   3f1b <unlink>
    26e7:	83 c4 10             	add    $0x10,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    26ea:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%ebp)
    26f1:	e9 a8 00 00 00       	jmp    279e <bigwrite+0xdc>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    26f6:	83 ec 08             	sub    $0x8,%esp
    26f9:	68 02 02 00 00       	push   $0x202
    26fe:	68 2b 52 00 00       	push   $0x522b
    2703:	e8 03 18 00 00       	call   3f0b <open>
    2708:	83 c4 10             	add    $0x10,%esp
    270b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    270e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2712:	79 17                	jns    272b <bigwrite+0x69>
      printf(1, "cannot create bigwrite\n");
    2714:	83 ec 08             	sub    $0x8,%esp
    2717:	68 34 52 00 00       	push   $0x5234
    271c:	6a 01                	push   $0x1
    271e:	e8 1b 19 00 00       	call   403e <printf>
    2723:	83 c4 10             	add    $0x10,%esp
      exit();
    2726:	e8 a0 17 00 00       	call   3ecb <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    272b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    2732:	eb 3f                	jmp    2773 <bigwrite+0xb1>
      int cc = write(fd, buf, sz);
    2734:	83 ec 04             	sub    $0x4,%esp
    2737:	ff 75 f4             	pushl  -0xc(%ebp)
    273a:	68 a0 8a 00 00       	push   $0x8aa0
    273f:	ff 75 ec             	pushl  -0x14(%ebp)
    2742:	e8 a4 17 00 00       	call   3eeb <write>
    2747:	83 c4 10             	add    $0x10,%esp
    274a:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(cc != sz){
    274d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2750:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    2753:	74 1a                	je     276f <bigwrite+0xad>
        printf(1, "write(%d) ret %d\n", sz, cc);
    2755:	ff 75 e8             	pushl  -0x18(%ebp)
    2758:	ff 75 f4             	pushl  -0xc(%ebp)
    275b:	68 4c 52 00 00       	push   $0x524c
    2760:	6a 01                	push   $0x1
    2762:	e8 d7 18 00 00       	call   403e <printf>
    2767:	83 c4 10             	add    $0x10,%esp
        exit();
    276a:	e8 5c 17 00 00       	call   3ecb <exit>
    for(i = 0; i < 2; i++){
    276f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    2773:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    2777:	7e bb                	jle    2734 <bigwrite+0x72>
      }
    }
    close(fd);
    2779:	83 ec 0c             	sub    $0xc,%esp
    277c:	ff 75 ec             	pushl  -0x14(%ebp)
    277f:	e8 6f 17 00 00       	call   3ef3 <close>
    2784:	83 c4 10             	add    $0x10,%esp
    unlink("bigwrite");
    2787:	83 ec 0c             	sub    $0xc,%esp
    278a:	68 2b 52 00 00       	push   $0x522b
    278f:	e8 87 17 00 00       	call   3f1b <unlink>
    2794:	83 c4 10             	add    $0x10,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    2797:	81 45 f4 d7 01 00 00 	addl   $0x1d7,-0xc(%ebp)
    279e:	81 7d f4 ff 17 00 00 	cmpl   $0x17ff,-0xc(%ebp)
    27a5:	0f 8e 4b ff ff ff    	jle    26f6 <bigwrite+0x34>
  }

  printf(1, "bigwrite ok\n");
    27ab:	83 ec 08             	sub    $0x8,%esp
    27ae:	68 5e 52 00 00       	push   $0x525e
    27b3:	6a 01                	push   $0x1
    27b5:	e8 84 18 00 00       	call   403e <printf>
    27ba:	83 c4 10             	add    $0x10,%esp
}
    27bd:	90                   	nop
    27be:	c9                   	leave  
    27bf:	c3                   	ret    

000027c0 <bigfile>:

void
bigfile(void)
{
    27c0:	55                   	push   %ebp
    27c1:	89 e5                	mov    %esp,%ebp
    27c3:	83 ec 18             	sub    $0x18,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    27c6:	83 ec 08             	sub    $0x8,%esp
    27c9:	68 6b 52 00 00       	push   $0x526b
    27ce:	6a 01                	push   $0x1
    27d0:	e8 69 18 00 00       	call   403e <printf>
    27d5:	83 c4 10             	add    $0x10,%esp

  unlink("bigfile");
    27d8:	83 ec 0c             	sub    $0xc,%esp
    27db:	68 79 52 00 00       	push   $0x5279
    27e0:	e8 36 17 00 00       	call   3f1b <unlink>
    27e5:	83 c4 10             	add    $0x10,%esp
  fd = open("bigfile", O_CREATE | O_RDWR);
    27e8:	83 ec 08             	sub    $0x8,%esp
    27eb:	68 02 02 00 00       	push   $0x202
    27f0:	68 79 52 00 00       	push   $0x5279
    27f5:	e8 11 17 00 00       	call   3f0b <open>
    27fa:	83 c4 10             	add    $0x10,%esp
    27fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    2800:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2804:	79 17                	jns    281d <bigfile+0x5d>
    printf(1, "cannot create bigfile");
    2806:	83 ec 08             	sub    $0x8,%esp
    2809:	68 81 52 00 00       	push   $0x5281
    280e:	6a 01                	push   $0x1
    2810:	e8 29 18 00 00       	call   403e <printf>
    2815:	83 c4 10             	add    $0x10,%esp
    exit();
    2818:	e8 ae 16 00 00       	call   3ecb <exit>
  }
  for(i = 0; i < 20; i++){
    281d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2824:	eb 52                	jmp    2878 <bigfile+0xb8>
    memset(buf, i, 600);
    2826:	83 ec 04             	sub    $0x4,%esp
    2829:	68 58 02 00 00       	push   $0x258
    282e:	ff 75 f4             	pushl  -0xc(%ebp)
    2831:	68 a0 8a 00 00       	push   $0x8aa0
    2836:	e8 f5 14 00 00       	call   3d30 <memset>
    283b:	83 c4 10             	add    $0x10,%esp
    if(write(fd, buf, 600) != 600){
    283e:	83 ec 04             	sub    $0x4,%esp
    2841:	68 58 02 00 00       	push   $0x258
    2846:	68 a0 8a 00 00       	push   $0x8aa0
    284b:	ff 75 ec             	pushl  -0x14(%ebp)
    284e:	e8 98 16 00 00       	call   3eeb <write>
    2853:	83 c4 10             	add    $0x10,%esp
    2856:	3d 58 02 00 00       	cmp    $0x258,%eax
    285b:	74 17                	je     2874 <bigfile+0xb4>
      printf(1, "write bigfile failed\n");
    285d:	83 ec 08             	sub    $0x8,%esp
    2860:	68 97 52 00 00       	push   $0x5297
    2865:	6a 01                	push   $0x1
    2867:	e8 d2 17 00 00       	call   403e <printf>
    286c:	83 c4 10             	add    $0x10,%esp
      exit();
    286f:	e8 57 16 00 00       	call   3ecb <exit>
  for(i = 0; i < 20; i++){
    2874:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2878:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    287c:	7e a8                	jle    2826 <bigfile+0x66>
    }
  }
  close(fd);
    287e:	83 ec 0c             	sub    $0xc,%esp
    2881:	ff 75 ec             	pushl  -0x14(%ebp)
    2884:	e8 6a 16 00 00       	call   3ef3 <close>
    2889:	83 c4 10             	add    $0x10,%esp

  fd = open("bigfile", 0);
    288c:	83 ec 08             	sub    $0x8,%esp
    288f:	6a 00                	push   $0x0
    2891:	68 79 52 00 00       	push   $0x5279
    2896:	e8 70 16 00 00       	call   3f0b <open>
    289b:	83 c4 10             	add    $0x10,%esp
    289e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    28a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    28a5:	79 17                	jns    28be <bigfile+0xfe>
    printf(1, "cannot open bigfile\n");
    28a7:	83 ec 08             	sub    $0x8,%esp
    28aa:	68 ad 52 00 00       	push   $0x52ad
    28af:	6a 01                	push   $0x1
    28b1:	e8 88 17 00 00       	call   403e <printf>
    28b6:	83 c4 10             	add    $0x10,%esp
    exit();
    28b9:	e8 0d 16 00 00       	call   3ecb <exit>
  }
  total = 0;
    28be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i = 0; ; i++){
    28c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    cc = read(fd, buf, 300);
    28cc:	83 ec 04             	sub    $0x4,%esp
    28cf:	68 2c 01 00 00       	push   $0x12c
    28d4:	68 a0 8a 00 00       	push   $0x8aa0
    28d9:	ff 75 ec             	pushl  -0x14(%ebp)
    28dc:	e8 02 16 00 00       	call   3ee3 <read>
    28e1:	83 c4 10             	add    $0x10,%esp
    28e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(cc < 0){
    28e7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    28eb:	79 17                	jns    2904 <bigfile+0x144>
      printf(1, "read bigfile failed\n");
    28ed:	83 ec 08             	sub    $0x8,%esp
    28f0:	68 c2 52 00 00       	push   $0x52c2
    28f5:	6a 01                	push   $0x1
    28f7:	e8 42 17 00 00       	call   403e <printf>
    28fc:	83 c4 10             	add    $0x10,%esp
      exit();
    28ff:	e8 c7 15 00 00       	call   3ecb <exit>
    }
    if(cc == 0)
    2904:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2908:	74 7a                	je     2984 <bigfile+0x1c4>
      break;
    if(cc != 300){
    290a:	81 7d e8 2c 01 00 00 	cmpl   $0x12c,-0x18(%ebp)
    2911:	74 17                	je     292a <bigfile+0x16a>
      printf(1, "short read bigfile\n");
    2913:	83 ec 08             	sub    $0x8,%esp
    2916:	68 d7 52 00 00       	push   $0x52d7
    291b:	6a 01                	push   $0x1
    291d:	e8 1c 17 00 00       	call   403e <printf>
    2922:	83 c4 10             	add    $0x10,%esp
      exit();
    2925:	e8 a1 15 00 00       	call   3ecb <exit>
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    292a:	0f b6 05 a0 8a 00 00 	movzbl 0x8aa0,%eax
    2931:	0f be d0             	movsbl %al,%edx
    2934:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2937:	89 c1                	mov    %eax,%ecx
    2939:	c1 e9 1f             	shr    $0x1f,%ecx
    293c:	01 c8                	add    %ecx,%eax
    293e:	d1 f8                	sar    %eax
    2940:	39 c2                	cmp    %eax,%edx
    2942:	75 1a                	jne    295e <bigfile+0x19e>
    2944:	0f b6 05 cb 8b 00 00 	movzbl 0x8bcb,%eax
    294b:	0f be d0             	movsbl %al,%edx
    294e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2951:	89 c1                	mov    %eax,%ecx
    2953:	c1 e9 1f             	shr    $0x1f,%ecx
    2956:	01 c8                	add    %ecx,%eax
    2958:	d1 f8                	sar    %eax
    295a:	39 c2                	cmp    %eax,%edx
    295c:	74 17                	je     2975 <bigfile+0x1b5>
      printf(1, "read bigfile wrong data\n");
    295e:	83 ec 08             	sub    $0x8,%esp
    2961:	68 eb 52 00 00       	push   $0x52eb
    2966:	6a 01                	push   $0x1
    2968:	e8 d1 16 00 00       	call   403e <printf>
    296d:	83 c4 10             	add    $0x10,%esp
      exit();
    2970:	e8 56 15 00 00       	call   3ecb <exit>
    }
    total += cc;
    2975:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2978:	01 45 f0             	add    %eax,-0x10(%ebp)
  for(i = 0; ; i++){
    297b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    cc = read(fd, buf, 300);
    297f:	e9 48 ff ff ff       	jmp    28cc <bigfile+0x10c>
      break;
    2984:	90                   	nop
  }
  close(fd);
    2985:	83 ec 0c             	sub    $0xc,%esp
    2988:	ff 75 ec             	pushl  -0x14(%ebp)
    298b:	e8 63 15 00 00       	call   3ef3 <close>
    2990:	83 c4 10             	add    $0x10,%esp
  if(total != 20*600){
    2993:	81 7d f0 e0 2e 00 00 	cmpl   $0x2ee0,-0x10(%ebp)
    299a:	74 17                	je     29b3 <bigfile+0x1f3>
    printf(1, "read bigfile wrong total\n");
    299c:	83 ec 08             	sub    $0x8,%esp
    299f:	68 04 53 00 00       	push   $0x5304
    29a4:	6a 01                	push   $0x1
    29a6:	e8 93 16 00 00       	call   403e <printf>
    29ab:	83 c4 10             	add    $0x10,%esp
    exit();
    29ae:	e8 18 15 00 00       	call   3ecb <exit>
  }
  unlink("bigfile");
    29b3:	83 ec 0c             	sub    $0xc,%esp
    29b6:	68 79 52 00 00       	push   $0x5279
    29bb:	e8 5b 15 00 00       	call   3f1b <unlink>
    29c0:	83 c4 10             	add    $0x10,%esp

  printf(1, "bigfile test ok\n");
    29c3:	83 ec 08             	sub    $0x8,%esp
    29c6:	68 1e 53 00 00       	push   $0x531e
    29cb:	6a 01                	push   $0x1
    29cd:	e8 6c 16 00 00       	call   403e <printf>
    29d2:	83 c4 10             	add    $0x10,%esp
}
    29d5:	90                   	nop
    29d6:	c9                   	leave  
    29d7:	c3                   	ret    

000029d8 <fourteen>:

void
fourteen(void)
{
    29d8:	55                   	push   %ebp
    29d9:	89 e5                	mov    %esp,%ebp
    29db:	83 ec 18             	sub    $0x18,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    29de:	83 ec 08             	sub    $0x8,%esp
    29e1:	68 2f 53 00 00       	push   $0x532f
    29e6:	6a 01                	push   $0x1
    29e8:	e8 51 16 00 00       	call   403e <printf>
    29ed:	83 c4 10             	add    $0x10,%esp

  if(mkdir("12345678901234") != 0){
    29f0:	83 ec 0c             	sub    $0xc,%esp
    29f3:	68 3e 53 00 00       	push   $0x533e
    29f8:	e8 36 15 00 00       	call   3f33 <mkdir>
    29fd:	83 c4 10             	add    $0x10,%esp
    2a00:	85 c0                	test   %eax,%eax
    2a02:	74 17                	je     2a1b <fourteen+0x43>
    printf(1, "mkdir 12345678901234 failed\n");
    2a04:	83 ec 08             	sub    $0x8,%esp
    2a07:	68 4d 53 00 00       	push   $0x534d
    2a0c:	6a 01                	push   $0x1
    2a0e:	e8 2b 16 00 00       	call   403e <printf>
    2a13:	83 c4 10             	add    $0x10,%esp
    exit();
    2a16:	e8 b0 14 00 00       	call   3ecb <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    2a1b:	83 ec 0c             	sub    $0xc,%esp
    2a1e:	68 6c 53 00 00       	push   $0x536c
    2a23:	e8 0b 15 00 00       	call   3f33 <mkdir>
    2a28:	83 c4 10             	add    $0x10,%esp
    2a2b:	85 c0                	test   %eax,%eax
    2a2d:	74 17                	je     2a46 <fourteen+0x6e>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    2a2f:	83 ec 08             	sub    $0x8,%esp
    2a32:	68 8c 53 00 00       	push   $0x538c
    2a37:	6a 01                	push   $0x1
    2a39:	e8 00 16 00 00       	call   403e <printf>
    2a3e:	83 c4 10             	add    $0x10,%esp
    exit();
    2a41:	e8 85 14 00 00       	call   3ecb <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2a46:	83 ec 08             	sub    $0x8,%esp
    2a49:	68 00 02 00 00       	push   $0x200
    2a4e:	68 bc 53 00 00       	push   $0x53bc
    2a53:	e8 b3 14 00 00       	call   3f0b <open>
    2a58:	83 c4 10             	add    $0x10,%esp
    2a5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2a5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2a62:	79 17                	jns    2a7b <fourteen+0xa3>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    2a64:	83 ec 08             	sub    $0x8,%esp
    2a67:	68 ec 53 00 00       	push   $0x53ec
    2a6c:	6a 01                	push   $0x1
    2a6e:	e8 cb 15 00 00       	call   403e <printf>
    2a73:	83 c4 10             	add    $0x10,%esp
    exit();
    2a76:	e8 50 14 00 00       	call   3ecb <exit>
  }
  close(fd);
    2a7b:	83 ec 0c             	sub    $0xc,%esp
    2a7e:	ff 75 f4             	pushl  -0xc(%ebp)
    2a81:	e8 6d 14 00 00       	call   3ef3 <close>
    2a86:	83 c4 10             	add    $0x10,%esp
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2a89:	83 ec 08             	sub    $0x8,%esp
    2a8c:	6a 00                	push   $0x0
    2a8e:	68 2c 54 00 00       	push   $0x542c
    2a93:	e8 73 14 00 00       	call   3f0b <open>
    2a98:	83 c4 10             	add    $0x10,%esp
    2a9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2a9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2aa2:	79 17                	jns    2abb <fourteen+0xe3>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2aa4:	83 ec 08             	sub    $0x8,%esp
    2aa7:	68 5c 54 00 00       	push   $0x545c
    2aac:	6a 01                	push   $0x1
    2aae:	e8 8b 15 00 00       	call   403e <printf>
    2ab3:	83 c4 10             	add    $0x10,%esp
    exit();
    2ab6:	e8 10 14 00 00       	call   3ecb <exit>
  }
  close(fd);
    2abb:	83 ec 0c             	sub    $0xc,%esp
    2abe:	ff 75 f4             	pushl  -0xc(%ebp)
    2ac1:	e8 2d 14 00 00       	call   3ef3 <close>
    2ac6:	83 c4 10             	add    $0x10,%esp

  if(mkdir("12345678901234/12345678901234") == 0){
    2ac9:	83 ec 0c             	sub    $0xc,%esp
    2acc:	68 96 54 00 00       	push   $0x5496
    2ad1:	e8 5d 14 00 00       	call   3f33 <mkdir>
    2ad6:	83 c4 10             	add    $0x10,%esp
    2ad9:	85 c0                	test   %eax,%eax
    2adb:	75 17                	jne    2af4 <fourteen+0x11c>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2add:	83 ec 08             	sub    $0x8,%esp
    2ae0:	68 b4 54 00 00       	push   $0x54b4
    2ae5:	6a 01                	push   $0x1
    2ae7:	e8 52 15 00 00       	call   403e <printf>
    2aec:	83 c4 10             	add    $0x10,%esp
    exit();
    2aef:	e8 d7 13 00 00       	call   3ecb <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2af4:	83 ec 0c             	sub    $0xc,%esp
    2af7:	68 e4 54 00 00       	push   $0x54e4
    2afc:	e8 32 14 00 00       	call   3f33 <mkdir>
    2b01:	83 c4 10             	add    $0x10,%esp
    2b04:	85 c0                	test   %eax,%eax
    2b06:	75 17                	jne    2b1f <fourteen+0x147>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2b08:	83 ec 08             	sub    $0x8,%esp
    2b0b:	68 04 55 00 00       	push   $0x5504
    2b10:	6a 01                	push   $0x1
    2b12:	e8 27 15 00 00       	call   403e <printf>
    2b17:	83 c4 10             	add    $0x10,%esp
    exit();
    2b1a:	e8 ac 13 00 00       	call   3ecb <exit>
  }

  printf(1, "fourteen ok\n");
    2b1f:	83 ec 08             	sub    $0x8,%esp
    2b22:	68 35 55 00 00       	push   $0x5535
    2b27:	6a 01                	push   $0x1
    2b29:	e8 10 15 00 00       	call   403e <printf>
    2b2e:	83 c4 10             	add    $0x10,%esp
}
    2b31:	90                   	nop
    2b32:	c9                   	leave  
    2b33:	c3                   	ret    

00002b34 <rmdot>:

void
rmdot(void)
{
    2b34:	55                   	push   %ebp
    2b35:	89 e5                	mov    %esp,%ebp
    2b37:	83 ec 08             	sub    $0x8,%esp
  printf(1, "rmdot test\n");
    2b3a:	83 ec 08             	sub    $0x8,%esp
    2b3d:	68 42 55 00 00       	push   $0x5542
    2b42:	6a 01                	push   $0x1
    2b44:	e8 f5 14 00 00       	call   403e <printf>
    2b49:	83 c4 10             	add    $0x10,%esp
  if(mkdir("dots") != 0){
    2b4c:	83 ec 0c             	sub    $0xc,%esp
    2b4f:	68 4e 55 00 00       	push   $0x554e
    2b54:	e8 da 13 00 00       	call   3f33 <mkdir>
    2b59:	83 c4 10             	add    $0x10,%esp
    2b5c:	85 c0                	test   %eax,%eax
    2b5e:	74 17                	je     2b77 <rmdot+0x43>
    printf(1, "mkdir dots failed\n");
    2b60:	83 ec 08             	sub    $0x8,%esp
    2b63:	68 53 55 00 00       	push   $0x5553
    2b68:	6a 01                	push   $0x1
    2b6a:	e8 cf 14 00 00       	call   403e <printf>
    2b6f:	83 c4 10             	add    $0x10,%esp
    exit();
    2b72:	e8 54 13 00 00       	call   3ecb <exit>
  }
  if(chdir("dots") != 0){
    2b77:	83 ec 0c             	sub    $0xc,%esp
    2b7a:	68 4e 55 00 00       	push   $0x554e
    2b7f:	e8 b7 13 00 00       	call   3f3b <chdir>
    2b84:	83 c4 10             	add    $0x10,%esp
    2b87:	85 c0                	test   %eax,%eax
    2b89:	74 17                	je     2ba2 <rmdot+0x6e>
    printf(1, "chdir dots failed\n");
    2b8b:	83 ec 08             	sub    $0x8,%esp
    2b8e:	68 66 55 00 00       	push   $0x5566
    2b93:	6a 01                	push   $0x1
    2b95:	e8 a4 14 00 00       	call   403e <printf>
    2b9a:	83 c4 10             	add    $0x10,%esp
    exit();
    2b9d:	e8 29 13 00 00       	call   3ecb <exit>
  }
  if(unlink(".") == 0){
    2ba2:	83 ec 0c             	sub    $0xc,%esp
    2ba5:	68 7f 4c 00 00       	push   $0x4c7f
    2baa:	e8 6c 13 00 00       	call   3f1b <unlink>
    2baf:	83 c4 10             	add    $0x10,%esp
    2bb2:	85 c0                	test   %eax,%eax
    2bb4:	75 17                	jne    2bcd <rmdot+0x99>
    printf(1, "rm . worked!\n");
    2bb6:	83 ec 08             	sub    $0x8,%esp
    2bb9:	68 79 55 00 00       	push   $0x5579
    2bbe:	6a 01                	push   $0x1
    2bc0:	e8 79 14 00 00       	call   403e <printf>
    2bc5:	83 c4 10             	add    $0x10,%esp
    exit();
    2bc8:	e8 fe 12 00 00       	call   3ecb <exit>
  }
  if(unlink("..") == 0){
    2bcd:	83 ec 0c             	sub    $0xc,%esp
    2bd0:	68 12 48 00 00       	push   $0x4812
    2bd5:	e8 41 13 00 00       	call   3f1b <unlink>
    2bda:	83 c4 10             	add    $0x10,%esp
    2bdd:	85 c0                	test   %eax,%eax
    2bdf:	75 17                	jne    2bf8 <rmdot+0xc4>
    printf(1, "rm .. worked!\n");
    2be1:	83 ec 08             	sub    $0x8,%esp
    2be4:	68 87 55 00 00       	push   $0x5587
    2be9:	6a 01                	push   $0x1
    2beb:	e8 4e 14 00 00       	call   403e <printf>
    2bf0:	83 c4 10             	add    $0x10,%esp
    exit();
    2bf3:	e8 d3 12 00 00       	call   3ecb <exit>
  }
  if(chdir("/") != 0){
    2bf8:	83 ec 0c             	sub    $0xc,%esp
    2bfb:	68 66 44 00 00       	push   $0x4466
    2c00:	e8 36 13 00 00       	call   3f3b <chdir>
    2c05:	83 c4 10             	add    $0x10,%esp
    2c08:	85 c0                	test   %eax,%eax
    2c0a:	74 17                	je     2c23 <rmdot+0xef>
    printf(1, "chdir / failed\n");
    2c0c:	83 ec 08             	sub    $0x8,%esp
    2c0f:	68 68 44 00 00       	push   $0x4468
    2c14:	6a 01                	push   $0x1
    2c16:	e8 23 14 00 00       	call   403e <printf>
    2c1b:	83 c4 10             	add    $0x10,%esp
    exit();
    2c1e:	e8 a8 12 00 00       	call   3ecb <exit>
  }
  if(unlink("dots/.") == 0){
    2c23:	83 ec 0c             	sub    $0xc,%esp
    2c26:	68 96 55 00 00       	push   $0x5596
    2c2b:	e8 eb 12 00 00       	call   3f1b <unlink>
    2c30:	83 c4 10             	add    $0x10,%esp
    2c33:	85 c0                	test   %eax,%eax
    2c35:	75 17                	jne    2c4e <rmdot+0x11a>
    printf(1, "unlink dots/. worked!\n");
    2c37:	83 ec 08             	sub    $0x8,%esp
    2c3a:	68 9d 55 00 00       	push   $0x559d
    2c3f:	6a 01                	push   $0x1
    2c41:	e8 f8 13 00 00       	call   403e <printf>
    2c46:	83 c4 10             	add    $0x10,%esp
    exit();
    2c49:	e8 7d 12 00 00       	call   3ecb <exit>
  }
  if(unlink("dots/..") == 0){
    2c4e:	83 ec 0c             	sub    $0xc,%esp
    2c51:	68 b4 55 00 00       	push   $0x55b4
    2c56:	e8 c0 12 00 00       	call   3f1b <unlink>
    2c5b:	83 c4 10             	add    $0x10,%esp
    2c5e:	85 c0                	test   %eax,%eax
    2c60:	75 17                	jne    2c79 <rmdot+0x145>
    printf(1, "unlink dots/.. worked!\n");
    2c62:	83 ec 08             	sub    $0x8,%esp
    2c65:	68 bc 55 00 00       	push   $0x55bc
    2c6a:	6a 01                	push   $0x1
    2c6c:	e8 cd 13 00 00       	call   403e <printf>
    2c71:	83 c4 10             	add    $0x10,%esp
    exit();
    2c74:	e8 52 12 00 00       	call   3ecb <exit>
  }
  if(unlink("dots") != 0){
    2c79:	83 ec 0c             	sub    $0xc,%esp
    2c7c:	68 4e 55 00 00       	push   $0x554e
    2c81:	e8 95 12 00 00       	call   3f1b <unlink>
    2c86:	83 c4 10             	add    $0x10,%esp
    2c89:	85 c0                	test   %eax,%eax
    2c8b:	74 17                	je     2ca4 <rmdot+0x170>
    printf(1, "unlink dots failed!\n");
    2c8d:	83 ec 08             	sub    $0x8,%esp
    2c90:	68 d4 55 00 00       	push   $0x55d4
    2c95:	6a 01                	push   $0x1
    2c97:	e8 a2 13 00 00       	call   403e <printf>
    2c9c:	83 c4 10             	add    $0x10,%esp
    exit();
    2c9f:	e8 27 12 00 00       	call   3ecb <exit>
  }
  printf(1, "rmdot ok\n");
    2ca4:	83 ec 08             	sub    $0x8,%esp
    2ca7:	68 e9 55 00 00       	push   $0x55e9
    2cac:	6a 01                	push   $0x1
    2cae:	e8 8b 13 00 00       	call   403e <printf>
    2cb3:	83 c4 10             	add    $0x10,%esp
}
    2cb6:	90                   	nop
    2cb7:	c9                   	leave  
    2cb8:	c3                   	ret    

00002cb9 <dirfile>:

void
dirfile(void)
{
    2cb9:	55                   	push   %ebp
    2cba:	89 e5                	mov    %esp,%ebp
    2cbc:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(1, "dir vs file\n");
    2cbf:	83 ec 08             	sub    $0x8,%esp
    2cc2:	68 f3 55 00 00       	push   $0x55f3
    2cc7:	6a 01                	push   $0x1
    2cc9:	e8 70 13 00 00       	call   403e <printf>
    2cce:	83 c4 10             	add    $0x10,%esp

  fd = open("dirfile", O_CREATE);
    2cd1:	83 ec 08             	sub    $0x8,%esp
    2cd4:	68 00 02 00 00       	push   $0x200
    2cd9:	68 00 56 00 00       	push   $0x5600
    2cde:	e8 28 12 00 00       	call   3f0b <open>
    2ce3:	83 c4 10             	add    $0x10,%esp
    2ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2ce9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2ced:	79 17                	jns    2d06 <dirfile+0x4d>
    printf(1, "create dirfile failed\n");
    2cef:	83 ec 08             	sub    $0x8,%esp
    2cf2:	68 08 56 00 00       	push   $0x5608
    2cf7:	6a 01                	push   $0x1
    2cf9:	e8 40 13 00 00       	call   403e <printf>
    2cfe:	83 c4 10             	add    $0x10,%esp
    exit();
    2d01:	e8 c5 11 00 00       	call   3ecb <exit>
  }
  close(fd);
    2d06:	83 ec 0c             	sub    $0xc,%esp
    2d09:	ff 75 f4             	pushl  -0xc(%ebp)
    2d0c:	e8 e2 11 00 00       	call   3ef3 <close>
    2d11:	83 c4 10             	add    $0x10,%esp
  if(chdir("dirfile") == 0){
    2d14:	83 ec 0c             	sub    $0xc,%esp
    2d17:	68 00 56 00 00       	push   $0x5600
    2d1c:	e8 1a 12 00 00       	call   3f3b <chdir>
    2d21:	83 c4 10             	add    $0x10,%esp
    2d24:	85 c0                	test   %eax,%eax
    2d26:	75 17                	jne    2d3f <dirfile+0x86>
    printf(1, "chdir dirfile succeeded!\n");
    2d28:	83 ec 08             	sub    $0x8,%esp
    2d2b:	68 1f 56 00 00       	push   $0x561f
    2d30:	6a 01                	push   $0x1
    2d32:	e8 07 13 00 00       	call   403e <printf>
    2d37:	83 c4 10             	add    $0x10,%esp
    exit();
    2d3a:	e8 8c 11 00 00       	call   3ecb <exit>
  }
  fd = open("dirfile/xx", 0);
    2d3f:	83 ec 08             	sub    $0x8,%esp
    2d42:	6a 00                	push   $0x0
    2d44:	68 39 56 00 00       	push   $0x5639
    2d49:	e8 bd 11 00 00       	call   3f0b <open>
    2d4e:	83 c4 10             	add    $0x10,%esp
    2d51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2d54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d58:	78 17                	js     2d71 <dirfile+0xb8>
    printf(1, "create dirfile/xx succeeded!\n");
    2d5a:	83 ec 08             	sub    $0x8,%esp
    2d5d:	68 44 56 00 00       	push   $0x5644
    2d62:	6a 01                	push   $0x1
    2d64:	e8 d5 12 00 00       	call   403e <printf>
    2d69:	83 c4 10             	add    $0x10,%esp
    exit();
    2d6c:	e8 5a 11 00 00       	call   3ecb <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    2d71:	83 ec 08             	sub    $0x8,%esp
    2d74:	68 00 02 00 00       	push   $0x200
    2d79:	68 39 56 00 00       	push   $0x5639
    2d7e:	e8 88 11 00 00       	call   3f0b <open>
    2d83:	83 c4 10             	add    $0x10,%esp
    2d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2d89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d8d:	78 17                	js     2da6 <dirfile+0xed>
    printf(1, "create dirfile/xx succeeded!\n");
    2d8f:	83 ec 08             	sub    $0x8,%esp
    2d92:	68 44 56 00 00       	push   $0x5644
    2d97:	6a 01                	push   $0x1
    2d99:	e8 a0 12 00 00       	call   403e <printf>
    2d9e:	83 c4 10             	add    $0x10,%esp
    exit();
    2da1:	e8 25 11 00 00       	call   3ecb <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    2da6:	83 ec 0c             	sub    $0xc,%esp
    2da9:	68 39 56 00 00       	push   $0x5639
    2dae:	e8 80 11 00 00       	call   3f33 <mkdir>
    2db3:	83 c4 10             	add    $0x10,%esp
    2db6:	85 c0                	test   %eax,%eax
    2db8:	75 17                	jne    2dd1 <dirfile+0x118>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2dba:	83 ec 08             	sub    $0x8,%esp
    2dbd:	68 62 56 00 00       	push   $0x5662
    2dc2:	6a 01                	push   $0x1
    2dc4:	e8 75 12 00 00       	call   403e <printf>
    2dc9:	83 c4 10             	add    $0x10,%esp
    exit();
    2dcc:	e8 fa 10 00 00       	call   3ecb <exit>
  }
  if(unlink("dirfile/xx") == 0){
    2dd1:	83 ec 0c             	sub    $0xc,%esp
    2dd4:	68 39 56 00 00       	push   $0x5639
    2dd9:	e8 3d 11 00 00       	call   3f1b <unlink>
    2dde:	83 c4 10             	add    $0x10,%esp
    2de1:	85 c0                	test   %eax,%eax
    2de3:	75 17                	jne    2dfc <dirfile+0x143>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2de5:	83 ec 08             	sub    $0x8,%esp
    2de8:	68 7f 56 00 00       	push   $0x567f
    2ded:	6a 01                	push   $0x1
    2def:	e8 4a 12 00 00       	call   403e <printf>
    2df4:	83 c4 10             	add    $0x10,%esp
    exit();
    2df7:	e8 cf 10 00 00       	call   3ecb <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    2dfc:	83 ec 08             	sub    $0x8,%esp
    2dff:	68 39 56 00 00       	push   $0x5639
    2e04:	68 9d 56 00 00       	push   $0x569d
    2e09:	e8 1d 11 00 00       	call   3f2b <link>
    2e0e:	83 c4 10             	add    $0x10,%esp
    2e11:	85 c0                	test   %eax,%eax
    2e13:	75 17                	jne    2e2c <dirfile+0x173>
    printf(1, "link to dirfile/xx succeeded!\n");
    2e15:	83 ec 08             	sub    $0x8,%esp
    2e18:	68 a4 56 00 00       	push   $0x56a4
    2e1d:	6a 01                	push   $0x1
    2e1f:	e8 1a 12 00 00       	call   403e <printf>
    2e24:	83 c4 10             	add    $0x10,%esp
    exit();
    2e27:	e8 9f 10 00 00       	call   3ecb <exit>
  }
  if(unlink("dirfile") != 0){
    2e2c:	83 ec 0c             	sub    $0xc,%esp
    2e2f:	68 00 56 00 00       	push   $0x5600
    2e34:	e8 e2 10 00 00       	call   3f1b <unlink>
    2e39:	83 c4 10             	add    $0x10,%esp
    2e3c:	85 c0                	test   %eax,%eax
    2e3e:	74 17                	je     2e57 <dirfile+0x19e>
    printf(1, "unlink dirfile failed!\n");
    2e40:	83 ec 08             	sub    $0x8,%esp
    2e43:	68 c3 56 00 00       	push   $0x56c3
    2e48:	6a 01                	push   $0x1
    2e4a:	e8 ef 11 00 00       	call   403e <printf>
    2e4f:	83 c4 10             	add    $0x10,%esp
    exit();
    2e52:	e8 74 10 00 00       	call   3ecb <exit>
  }

  fd = open(".", O_RDWR);
    2e57:	83 ec 08             	sub    $0x8,%esp
    2e5a:	6a 02                	push   $0x2
    2e5c:	68 7f 4c 00 00       	push   $0x4c7f
    2e61:	e8 a5 10 00 00       	call   3f0b <open>
    2e66:	83 c4 10             	add    $0x10,%esp
    2e69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2e6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2e70:	78 17                	js     2e89 <dirfile+0x1d0>
    printf(1, "open . for writing succeeded!\n");
    2e72:	83 ec 08             	sub    $0x8,%esp
    2e75:	68 dc 56 00 00       	push   $0x56dc
    2e7a:	6a 01                	push   $0x1
    2e7c:	e8 bd 11 00 00       	call   403e <printf>
    2e81:	83 c4 10             	add    $0x10,%esp
    exit();
    2e84:	e8 42 10 00 00       	call   3ecb <exit>
  }
  fd = open(".", 0);
    2e89:	83 ec 08             	sub    $0x8,%esp
    2e8c:	6a 00                	push   $0x0
    2e8e:	68 7f 4c 00 00       	push   $0x4c7f
    2e93:	e8 73 10 00 00       	call   3f0b <open>
    2e98:	83 c4 10             	add    $0x10,%esp
    2e9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(write(fd, "x", 1) > 0){
    2e9e:	83 ec 04             	sub    $0x4,%esp
    2ea1:	6a 01                	push   $0x1
    2ea3:	68 cb 48 00 00       	push   $0x48cb
    2ea8:	ff 75 f4             	pushl  -0xc(%ebp)
    2eab:	e8 3b 10 00 00       	call   3eeb <write>
    2eb0:	83 c4 10             	add    $0x10,%esp
    2eb3:	85 c0                	test   %eax,%eax
    2eb5:	7e 17                	jle    2ece <dirfile+0x215>
    printf(1, "write . succeeded!\n");
    2eb7:	83 ec 08             	sub    $0x8,%esp
    2eba:	68 fb 56 00 00       	push   $0x56fb
    2ebf:	6a 01                	push   $0x1
    2ec1:	e8 78 11 00 00       	call   403e <printf>
    2ec6:	83 c4 10             	add    $0x10,%esp
    exit();
    2ec9:	e8 fd 0f 00 00       	call   3ecb <exit>
  }
  close(fd);
    2ece:	83 ec 0c             	sub    $0xc,%esp
    2ed1:	ff 75 f4             	pushl  -0xc(%ebp)
    2ed4:	e8 1a 10 00 00       	call   3ef3 <close>
    2ed9:	83 c4 10             	add    $0x10,%esp

  printf(1, "dir vs file OK\n");
    2edc:	83 ec 08             	sub    $0x8,%esp
    2edf:	68 0f 57 00 00       	push   $0x570f
    2ee4:	6a 01                	push   $0x1
    2ee6:	e8 53 11 00 00       	call   403e <printf>
    2eeb:	83 c4 10             	add    $0x10,%esp
}
    2eee:	90                   	nop
    2eef:	c9                   	leave  
    2ef0:	c3                   	ret    

00002ef1 <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2ef1:	55                   	push   %ebp
    2ef2:	89 e5                	mov    %esp,%ebp
    2ef4:	83 ec 18             	sub    $0x18,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2ef7:	83 ec 08             	sub    $0x8,%esp
    2efa:	68 1f 57 00 00       	push   $0x571f
    2eff:	6a 01                	push   $0x1
    2f01:	e8 38 11 00 00       	call   403e <printf>
    2f06:	83 c4 10             	add    $0x10,%esp

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2f09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2f10:	e9 e7 00 00 00       	jmp    2ffc <iref+0x10b>
    if(mkdir("irefd") != 0){
    2f15:	83 ec 0c             	sub    $0xc,%esp
    2f18:	68 30 57 00 00       	push   $0x5730
    2f1d:	e8 11 10 00 00       	call   3f33 <mkdir>
    2f22:	83 c4 10             	add    $0x10,%esp
    2f25:	85 c0                	test   %eax,%eax
    2f27:	74 17                	je     2f40 <iref+0x4f>
      printf(1, "mkdir irefd failed\n");
    2f29:	83 ec 08             	sub    $0x8,%esp
    2f2c:	68 36 57 00 00       	push   $0x5736
    2f31:	6a 01                	push   $0x1
    2f33:	e8 06 11 00 00       	call   403e <printf>
    2f38:	83 c4 10             	add    $0x10,%esp
      exit();
    2f3b:	e8 8b 0f 00 00       	call   3ecb <exit>
    }
    if(chdir("irefd") != 0){
    2f40:	83 ec 0c             	sub    $0xc,%esp
    2f43:	68 30 57 00 00       	push   $0x5730
    2f48:	e8 ee 0f 00 00       	call   3f3b <chdir>
    2f4d:	83 c4 10             	add    $0x10,%esp
    2f50:	85 c0                	test   %eax,%eax
    2f52:	74 17                	je     2f6b <iref+0x7a>
      printf(1, "chdir irefd failed\n");
    2f54:	83 ec 08             	sub    $0x8,%esp
    2f57:	68 4a 57 00 00       	push   $0x574a
    2f5c:	6a 01                	push   $0x1
    2f5e:	e8 db 10 00 00       	call   403e <printf>
    2f63:	83 c4 10             	add    $0x10,%esp
      exit();
    2f66:	e8 60 0f 00 00       	call   3ecb <exit>
    }

    mkdir("");
    2f6b:	83 ec 0c             	sub    $0xc,%esp
    2f6e:	68 5e 57 00 00       	push   $0x575e
    2f73:	e8 bb 0f 00 00       	call   3f33 <mkdir>
    2f78:	83 c4 10             	add    $0x10,%esp
    link("README", "");
    2f7b:	83 ec 08             	sub    $0x8,%esp
    2f7e:	68 5e 57 00 00       	push   $0x575e
    2f83:	68 9d 56 00 00       	push   $0x569d
    2f88:	e8 9e 0f 00 00       	call   3f2b <link>
    2f8d:	83 c4 10             	add    $0x10,%esp
    fd = open("", O_CREATE);
    2f90:	83 ec 08             	sub    $0x8,%esp
    2f93:	68 00 02 00 00       	push   $0x200
    2f98:	68 5e 57 00 00       	push   $0x575e
    2f9d:	e8 69 0f 00 00       	call   3f0b <open>
    2fa2:	83 c4 10             	add    $0x10,%esp
    2fa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2fa8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2fac:	78 0e                	js     2fbc <iref+0xcb>
      close(fd);
    2fae:	83 ec 0c             	sub    $0xc,%esp
    2fb1:	ff 75 f0             	pushl  -0x10(%ebp)
    2fb4:	e8 3a 0f 00 00       	call   3ef3 <close>
    2fb9:	83 c4 10             	add    $0x10,%esp
    fd = open("xx", O_CREATE);
    2fbc:	83 ec 08             	sub    $0x8,%esp
    2fbf:	68 00 02 00 00       	push   $0x200
    2fc4:	68 5f 57 00 00       	push   $0x575f
    2fc9:	e8 3d 0f 00 00       	call   3f0b <open>
    2fce:	83 c4 10             	add    $0x10,%esp
    2fd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2fd4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2fd8:	78 0e                	js     2fe8 <iref+0xf7>
      close(fd);
    2fda:	83 ec 0c             	sub    $0xc,%esp
    2fdd:	ff 75 f0             	pushl  -0x10(%ebp)
    2fe0:	e8 0e 0f 00 00       	call   3ef3 <close>
    2fe5:	83 c4 10             	add    $0x10,%esp
    unlink("xx");
    2fe8:	83 ec 0c             	sub    $0xc,%esp
    2feb:	68 5f 57 00 00       	push   $0x575f
    2ff0:	e8 26 0f 00 00       	call   3f1b <unlink>
    2ff5:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 50 + 1; i++){
    2ff8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2ffc:	83 7d f4 32          	cmpl   $0x32,-0xc(%ebp)
    3000:	0f 8e 0f ff ff ff    	jle    2f15 <iref+0x24>
  }

  chdir("/");
    3006:	83 ec 0c             	sub    $0xc,%esp
    3009:	68 66 44 00 00       	push   $0x4466
    300e:	e8 28 0f 00 00       	call   3f3b <chdir>
    3013:	83 c4 10             	add    $0x10,%esp
  printf(1, "empty file name OK\n");
    3016:	83 ec 08             	sub    $0x8,%esp
    3019:	68 62 57 00 00       	push   $0x5762
    301e:	6a 01                	push   $0x1
    3020:	e8 19 10 00 00       	call   403e <printf>
    3025:	83 c4 10             	add    $0x10,%esp
}
    3028:	90                   	nop
    3029:	c9                   	leave  
    302a:	c3                   	ret    

0000302b <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    302b:	55                   	push   %ebp
    302c:	89 e5                	mov    %esp,%ebp
    302e:	83 ec 18             	sub    $0x18,%esp
  int n, pid;

  printf(1, "fork test\n");
    3031:	83 ec 08             	sub    $0x8,%esp
    3034:	68 76 57 00 00       	push   $0x5776
    3039:	6a 01                	push   $0x1
    303b:	e8 fe 0f 00 00       	call   403e <printf>
    3040:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<1000; n++){
    3043:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    304a:	eb 1d                	jmp    3069 <forktest+0x3e>
    pid = fork();
    304c:	e8 72 0e 00 00       	call   3ec3 <fork>
    3051:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
    3054:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3058:	78 1a                	js     3074 <forktest+0x49>
      break;
    if(pid == 0)
    305a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    305e:	75 05                	jne    3065 <forktest+0x3a>
      exit();
    3060:	e8 66 0e 00 00       	call   3ecb <exit>
  for(n=0; n<1000; n++){
    3065:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3069:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
    3070:	7e da                	jle    304c <forktest+0x21>
    3072:	eb 01                	jmp    3075 <forktest+0x4a>
      break;
    3074:	90                   	nop
  }
  
  if(n == 1000){
    3075:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
    307c:	75 3b                	jne    30b9 <forktest+0x8e>
    printf(1, "fork claimed to work 1000 times!\n");
    307e:	83 ec 08             	sub    $0x8,%esp
    3081:	68 84 57 00 00       	push   $0x5784
    3086:	6a 01                	push   $0x1
    3088:	e8 b1 0f 00 00       	call   403e <printf>
    308d:	83 c4 10             	add    $0x10,%esp
    exit();
    3090:	e8 36 0e 00 00       	call   3ecb <exit>
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
    3095:	e8 39 0e 00 00       	call   3ed3 <wait>
    309a:	85 c0                	test   %eax,%eax
    309c:	79 17                	jns    30b5 <forktest+0x8a>
      printf(1, "wait stopped early\n");
    309e:	83 ec 08             	sub    $0x8,%esp
    30a1:	68 a6 57 00 00       	push   $0x57a6
    30a6:	6a 01                	push   $0x1
    30a8:	e8 91 0f 00 00       	call   403e <printf>
    30ad:	83 c4 10             	add    $0x10,%esp
      exit();
    30b0:	e8 16 0e 00 00       	call   3ecb <exit>
  for(; n > 0; n--){
    30b5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    30b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    30bd:	7f d6                	jg     3095 <forktest+0x6a>
    }
  }
  
  if(wait() != -1){
    30bf:	e8 0f 0e 00 00       	call   3ed3 <wait>
    30c4:	83 f8 ff             	cmp    $0xffffffff,%eax
    30c7:	74 17                	je     30e0 <forktest+0xb5>
    printf(1, "wait got too many\n");
    30c9:	83 ec 08             	sub    $0x8,%esp
    30cc:	68 ba 57 00 00       	push   $0x57ba
    30d1:	6a 01                	push   $0x1
    30d3:	e8 66 0f 00 00       	call   403e <printf>
    30d8:	83 c4 10             	add    $0x10,%esp
    exit();
    30db:	e8 eb 0d 00 00       	call   3ecb <exit>
  }
  
  printf(1, "fork test OK\n");
    30e0:	83 ec 08             	sub    $0x8,%esp
    30e3:	68 cd 57 00 00       	push   $0x57cd
    30e8:	6a 01                	push   $0x1
    30ea:	e8 4f 0f 00 00       	call   403e <printf>
    30ef:	83 c4 10             	add    $0x10,%esp
}
    30f2:	90                   	nop
    30f3:	c9                   	leave  
    30f4:	c3                   	ret    

000030f5 <sbrktest>:

void
sbrktest(void)
{
    30f5:	55                   	push   %ebp
    30f6:	89 e5                	mov    %esp,%ebp
    30f8:	83 ec 68             	sub    $0x68,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    30fb:	a1 a8 62 00 00       	mov    0x62a8,%eax
    3100:	83 ec 08             	sub    $0x8,%esp
    3103:	68 db 57 00 00       	push   $0x57db
    3108:	50                   	push   %eax
    3109:	e8 30 0f 00 00       	call   403e <printf>
    310e:	83 c4 10             	add    $0x10,%esp
  oldbrk = sbrk(0);
    3111:	83 ec 0c             	sub    $0xc,%esp
    3114:	6a 00                	push   $0x0
    3116:	e8 38 0e 00 00       	call   3f53 <sbrk>
    311b:	83 c4 10             	add    $0x10,%esp
    311e:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    3121:	83 ec 0c             	sub    $0xc,%esp
    3124:	6a 00                	push   $0x0
    3126:	e8 28 0e 00 00       	call   3f53 <sbrk>
    312b:	83 c4 10             	add    $0x10,%esp
    312e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int i;
  for(i = 0; i < 5000; i++){ 
    3131:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3138:	eb 4f                	jmp    3189 <sbrktest+0x94>
    b = sbrk(1);
    313a:	83 ec 0c             	sub    $0xc,%esp
    313d:	6a 01                	push   $0x1
    313f:	e8 0f 0e 00 00       	call   3f53 <sbrk>
    3144:	83 c4 10             	add    $0x10,%esp
    3147:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(b != a){
    314a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    314d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3150:	74 24                	je     3176 <sbrktest+0x81>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    3152:	a1 a8 62 00 00       	mov    0x62a8,%eax
    3157:	83 ec 0c             	sub    $0xc,%esp
    315a:	ff 75 e8             	pushl  -0x18(%ebp)
    315d:	ff 75 f4             	pushl  -0xc(%ebp)
    3160:	ff 75 f0             	pushl  -0x10(%ebp)
    3163:	68 e6 57 00 00       	push   $0x57e6
    3168:	50                   	push   %eax
    3169:	e8 d0 0e 00 00       	call   403e <printf>
    316e:	83 c4 20             	add    $0x20,%esp
      exit();
    3171:	e8 55 0d 00 00       	call   3ecb <exit>
    }
    *b = 1;
    3176:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3179:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    317c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    317f:	83 c0 01             	add    $0x1,%eax
    3182:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; i < 5000; i++){ 
    3185:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3189:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
    3190:	7e a8                	jle    313a <sbrktest+0x45>
  }
  pid = fork();
    3192:	e8 2c 0d 00 00       	call   3ec3 <fork>
    3197:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    319a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    319e:	79 1b                	jns    31bb <sbrktest+0xc6>
    printf(stdout, "sbrk test fork failed\n");
    31a0:	a1 a8 62 00 00       	mov    0x62a8,%eax
    31a5:	83 ec 08             	sub    $0x8,%esp
    31a8:	68 01 58 00 00       	push   $0x5801
    31ad:	50                   	push   %eax
    31ae:	e8 8b 0e 00 00       	call   403e <printf>
    31b3:	83 c4 10             	add    $0x10,%esp
    exit();
    31b6:	e8 10 0d 00 00       	call   3ecb <exit>
  }
  c = sbrk(1);
    31bb:	83 ec 0c             	sub    $0xc,%esp
    31be:	6a 01                	push   $0x1
    31c0:	e8 8e 0d 00 00       	call   3f53 <sbrk>
    31c5:	83 c4 10             	add    $0x10,%esp
    31c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  c = sbrk(1);
    31cb:	83 ec 0c             	sub    $0xc,%esp
    31ce:	6a 01                	push   $0x1
    31d0:	e8 7e 0d 00 00       	call   3f53 <sbrk>
    31d5:	83 c4 10             	add    $0x10,%esp
    31d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a + 1){
    31db:	8b 45 f4             	mov    -0xc(%ebp),%eax
    31de:	83 c0 01             	add    $0x1,%eax
    31e1:	39 45 e0             	cmp    %eax,-0x20(%ebp)
    31e4:	74 1b                	je     3201 <sbrktest+0x10c>
    printf(stdout, "sbrk test failed post-fork\n");
    31e6:	a1 a8 62 00 00       	mov    0x62a8,%eax
    31eb:	83 ec 08             	sub    $0x8,%esp
    31ee:	68 18 58 00 00       	push   $0x5818
    31f3:	50                   	push   %eax
    31f4:	e8 45 0e 00 00       	call   403e <printf>
    31f9:	83 c4 10             	add    $0x10,%esp
    exit();
    31fc:	e8 ca 0c 00 00       	call   3ecb <exit>
  }
  if(pid == 0)
    3201:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3205:	75 05                	jne    320c <sbrktest+0x117>
    exit();
    3207:	e8 bf 0c 00 00       	call   3ecb <exit>
  wait();
    320c:	e8 c2 0c 00 00       	call   3ed3 <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    3211:	83 ec 0c             	sub    $0xc,%esp
    3214:	6a 00                	push   $0x0
    3216:	e8 38 0d 00 00       	call   3f53 <sbrk>
    321b:	83 c4 10             	add    $0x10,%esp
    321e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  amt = (BIG) - (uint)a;
    3221:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3224:	ba 00 00 40 06       	mov    $0x6400000,%edx
    3229:	29 c2                	sub    %eax,%edx
    322b:	89 d0                	mov    %edx,%eax
    322d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  p = sbrk(amt);
    3230:	8b 45 dc             	mov    -0x24(%ebp),%eax
    3233:	83 ec 0c             	sub    $0xc,%esp
    3236:	50                   	push   %eax
    3237:	e8 17 0d 00 00       	call   3f53 <sbrk>
    323c:	83 c4 10             	add    $0x10,%esp
    323f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if (p != a) { 
    3242:	8b 45 d8             	mov    -0x28(%ebp),%eax
    3245:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3248:	74 1b                	je     3265 <sbrktest+0x170>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    324a:	a1 a8 62 00 00       	mov    0x62a8,%eax
    324f:	83 ec 08             	sub    $0x8,%esp
    3252:	68 34 58 00 00       	push   $0x5834
    3257:	50                   	push   %eax
    3258:	e8 e1 0d 00 00       	call   403e <printf>
    325d:	83 c4 10             	add    $0x10,%esp
    exit();
    3260:	e8 66 0c 00 00       	call   3ecb <exit>
  }
  lastaddr = (char*) (BIG-1);
    3265:	c7 45 d4 ff ff 3f 06 	movl   $0x63fffff,-0x2c(%ebp)
  *lastaddr = 99;
    326c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    326f:	c6 00 63             	movb   $0x63,(%eax)

  // can one de-allocate?
  a = sbrk(0);
    3272:	83 ec 0c             	sub    $0xc,%esp
    3275:	6a 00                	push   $0x0
    3277:	e8 d7 0c 00 00       	call   3f53 <sbrk>
    327c:	83 c4 10             	add    $0x10,%esp
    327f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-4096);
    3282:	83 ec 0c             	sub    $0xc,%esp
    3285:	68 00 f0 ff ff       	push   $0xfffff000
    328a:	e8 c4 0c 00 00       	call   3f53 <sbrk>
    328f:	83 c4 10             	add    $0x10,%esp
    3292:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c == (char*)0xffffffff){
    3295:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    3299:	75 1b                	jne    32b6 <sbrktest+0x1c1>
    printf(stdout, "sbrk could not deallocate\n");
    329b:	a1 a8 62 00 00       	mov    0x62a8,%eax
    32a0:	83 ec 08             	sub    $0x8,%esp
    32a3:	68 72 58 00 00       	push   $0x5872
    32a8:	50                   	push   %eax
    32a9:	e8 90 0d 00 00       	call   403e <printf>
    32ae:	83 c4 10             	add    $0x10,%esp
    exit();
    32b1:	e8 15 0c 00 00       	call   3ecb <exit>
  }
  c = sbrk(0);
    32b6:	83 ec 0c             	sub    $0xc,%esp
    32b9:	6a 00                	push   $0x0
    32bb:	e8 93 0c 00 00       	call   3f53 <sbrk>
    32c0:	83 c4 10             	add    $0x10,%esp
    32c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a - 4096){
    32c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    32c9:	2d 00 10 00 00       	sub    $0x1000,%eax
    32ce:	39 45 e0             	cmp    %eax,-0x20(%ebp)
    32d1:	74 1e                	je     32f1 <sbrktest+0x1fc>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    32d3:	a1 a8 62 00 00       	mov    0x62a8,%eax
    32d8:	ff 75 e0             	pushl  -0x20(%ebp)
    32db:	ff 75 f4             	pushl  -0xc(%ebp)
    32de:	68 90 58 00 00       	push   $0x5890
    32e3:	50                   	push   %eax
    32e4:	e8 55 0d 00 00       	call   403e <printf>
    32e9:	83 c4 10             	add    $0x10,%esp
    exit();
    32ec:	e8 da 0b 00 00       	call   3ecb <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    32f1:	83 ec 0c             	sub    $0xc,%esp
    32f4:	6a 00                	push   $0x0
    32f6:	e8 58 0c 00 00       	call   3f53 <sbrk>
    32fb:	83 c4 10             	add    $0x10,%esp
    32fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(4096);
    3301:	83 ec 0c             	sub    $0xc,%esp
    3304:	68 00 10 00 00       	push   $0x1000
    3309:	e8 45 0c 00 00       	call   3f53 <sbrk>
    330e:	83 c4 10             	add    $0x10,%esp
    3311:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a || sbrk(0) != a + 4096){
    3314:	8b 45 e0             	mov    -0x20(%ebp),%eax
    3317:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    331a:	75 1b                	jne    3337 <sbrktest+0x242>
    331c:	83 ec 0c             	sub    $0xc,%esp
    331f:	6a 00                	push   $0x0
    3321:	e8 2d 0c 00 00       	call   3f53 <sbrk>
    3326:	83 c4 10             	add    $0x10,%esp
    3329:	89 c2                	mov    %eax,%edx
    332b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    332e:	05 00 10 00 00       	add    $0x1000,%eax
    3333:	39 c2                	cmp    %eax,%edx
    3335:	74 1e                	je     3355 <sbrktest+0x260>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    3337:	a1 a8 62 00 00       	mov    0x62a8,%eax
    333c:	ff 75 e0             	pushl  -0x20(%ebp)
    333f:	ff 75 f4             	pushl  -0xc(%ebp)
    3342:	68 c8 58 00 00       	push   $0x58c8
    3347:	50                   	push   %eax
    3348:	e8 f1 0c 00 00       	call   403e <printf>
    334d:	83 c4 10             	add    $0x10,%esp
    exit();
    3350:	e8 76 0b 00 00       	call   3ecb <exit>
  }
  if(*lastaddr == 99){
    3355:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3358:	0f b6 00             	movzbl (%eax),%eax
    335b:	3c 63                	cmp    $0x63,%al
    335d:	75 1b                	jne    337a <sbrktest+0x285>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    335f:	a1 a8 62 00 00       	mov    0x62a8,%eax
    3364:	83 ec 08             	sub    $0x8,%esp
    3367:	68 f0 58 00 00       	push   $0x58f0
    336c:	50                   	push   %eax
    336d:	e8 cc 0c 00 00       	call   403e <printf>
    3372:	83 c4 10             	add    $0x10,%esp
    exit();
    3375:	e8 51 0b 00 00       	call   3ecb <exit>
  }

  a = sbrk(0);
    337a:	83 ec 0c             	sub    $0xc,%esp
    337d:	6a 00                	push   $0x0
    337f:	e8 cf 0b 00 00       	call   3f53 <sbrk>
    3384:	83 c4 10             	add    $0x10,%esp
    3387:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-(sbrk(0) - oldbrk));
    338a:	83 ec 0c             	sub    $0xc,%esp
    338d:	6a 00                	push   $0x0
    338f:	e8 bf 0b 00 00       	call   3f53 <sbrk>
    3394:	83 c4 10             	add    $0x10,%esp
    3397:	89 c2                	mov    %eax,%edx
    3399:	8b 45 ec             	mov    -0x14(%ebp),%eax
    339c:	29 d0                	sub    %edx,%eax
    339e:	83 ec 0c             	sub    $0xc,%esp
    33a1:	50                   	push   %eax
    33a2:	e8 ac 0b 00 00       	call   3f53 <sbrk>
    33a7:	83 c4 10             	add    $0x10,%esp
    33aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a){
    33ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
    33b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    33b3:	74 1e                	je     33d3 <sbrktest+0x2de>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    33b5:	a1 a8 62 00 00       	mov    0x62a8,%eax
    33ba:	ff 75 e0             	pushl  -0x20(%ebp)
    33bd:	ff 75 f4             	pushl  -0xc(%ebp)
    33c0:	68 20 59 00 00       	push   $0x5920
    33c5:	50                   	push   %eax
    33c6:	e8 73 0c 00 00       	call   403e <printf>
    33cb:	83 c4 10             	add    $0x10,%esp
    exit();
    33ce:	e8 f8 0a 00 00       	call   3ecb <exit>
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    33d3:	c7 45 f4 00 00 00 80 	movl   $0x80000000,-0xc(%ebp)
    33da:	eb 76                	jmp    3452 <sbrktest+0x35d>
    ppid = getpid();
    33dc:	e8 6a 0b 00 00       	call   3f4b <getpid>
    33e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
    pid = fork();
    33e4:	e8 da 0a 00 00       	call   3ec3 <fork>
    33e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pid < 0){
    33ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    33f0:	79 1b                	jns    340d <sbrktest+0x318>
      printf(stdout, "fork failed\n");
    33f2:	a1 a8 62 00 00       	mov    0x62a8,%eax
    33f7:	83 ec 08             	sub    $0x8,%esp
    33fa:	68 95 44 00 00       	push   $0x4495
    33ff:	50                   	push   %eax
    3400:	e8 39 0c 00 00       	call   403e <printf>
    3405:	83 c4 10             	add    $0x10,%esp
      exit();
    3408:	e8 be 0a 00 00       	call   3ecb <exit>
    }
    if(pid == 0){
    340d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3411:	75 33                	jne    3446 <sbrktest+0x351>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    3413:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3416:	0f b6 00             	movzbl (%eax),%eax
    3419:	0f be d0             	movsbl %al,%edx
    341c:	a1 a8 62 00 00       	mov    0x62a8,%eax
    3421:	52                   	push   %edx
    3422:	ff 75 f4             	pushl  -0xc(%ebp)
    3425:	68 41 59 00 00       	push   $0x5941
    342a:	50                   	push   %eax
    342b:	e8 0e 0c 00 00       	call   403e <printf>
    3430:	83 c4 10             	add    $0x10,%esp
      kill(ppid);
    3433:	83 ec 0c             	sub    $0xc,%esp
    3436:	ff 75 d0             	pushl  -0x30(%ebp)
    3439:	e8 bd 0a 00 00       	call   3efb <kill>
    343e:	83 c4 10             	add    $0x10,%esp
      exit();
    3441:	e8 85 0a 00 00       	call   3ecb <exit>
    }
    wait();
    3446:	e8 88 0a 00 00       	call   3ed3 <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    344b:	81 45 f4 50 c3 00 00 	addl   $0xc350,-0xc(%ebp)
    3452:	81 7d f4 7f 84 1e 80 	cmpl   $0x801e847f,-0xc(%ebp)
    3459:	76 81                	jbe    33dc <sbrktest+0x2e7>
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    345b:	83 ec 0c             	sub    $0xc,%esp
    345e:	8d 45 c8             	lea    -0x38(%ebp),%eax
    3461:	50                   	push   %eax
    3462:	e8 74 0a 00 00       	call   3edb <pipe>
    3467:	83 c4 10             	add    $0x10,%esp
    346a:	85 c0                	test   %eax,%eax
    346c:	74 17                	je     3485 <sbrktest+0x390>
    printf(1, "pipe() failed\n");
    346e:	83 ec 08             	sub    $0x8,%esp
    3471:	68 66 48 00 00       	push   $0x4866
    3476:	6a 01                	push   $0x1
    3478:	e8 c1 0b 00 00       	call   403e <printf>
    347d:	83 c4 10             	add    $0x10,%esp
    exit();
    3480:	e8 46 0a 00 00       	call   3ecb <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3485:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    348c:	e9 88 00 00 00       	jmp    3519 <sbrktest+0x424>
    if((pids[i] = fork()) == 0){
    3491:	e8 2d 0a 00 00       	call   3ec3 <fork>
    3496:	89 c2                	mov    %eax,%edx
    3498:	8b 45 f0             	mov    -0x10(%ebp),%eax
    349b:	89 54 85 a0          	mov    %edx,-0x60(%ebp,%eax,4)
    349f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    34a2:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    34a6:	85 c0                	test   %eax,%eax
    34a8:	75 4a                	jne    34f4 <sbrktest+0x3ff>
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    34aa:	83 ec 0c             	sub    $0xc,%esp
    34ad:	6a 00                	push   $0x0
    34af:	e8 9f 0a 00 00       	call   3f53 <sbrk>
    34b4:	83 c4 10             	add    $0x10,%esp
    34b7:	ba 00 00 40 06       	mov    $0x6400000,%edx
    34bc:	29 c2                	sub    %eax,%edx
    34be:	89 d0                	mov    %edx,%eax
    34c0:	83 ec 0c             	sub    $0xc,%esp
    34c3:	50                   	push   %eax
    34c4:	e8 8a 0a 00 00       	call   3f53 <sbrk>
    34c9:	83 c4 10             	add    $0x10,%esp
      write(fds[1], "x", 1);
    34cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
    34cf:	83 ec 04             	sub    $0x4,%esp
    34d2:	6a 01                	push   $0x1
    34d4:	68 cb 48 00 00       	push   $0x48cb
    34d9:	50                   	push   %eax
    34da:	e8 0c 0a 00 00       	call   3eeb <write>
    34df:	83 c4 10             	add    $0x10,%esp
      // sit around until killed
      for(;;) sleep(1000);
    34e2:	83 ec 0c             	sub    $0xc,%esp
    34e5:	68 e8 03 00 00       	push   $0x3e8
    34ea:	e8 6c 0a 00 00       	call   3f5b <sleep>
    34ef:	83 c4 10             	add    $0x10,%esp
    34f2:	eb ee                	jmp    34e2 <sbrktest+0x3ed>
    }
    if(pids[i] != -1)
    34f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    34f7:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    34fb:	83 f8 ff             	cmp    $0xffffffff,%eax
    34fe:	74 15                	je     3515 <sbrktest+0x420>
      read(fds[0], &scratch, 1);
    3500:	8b 45 c8             	mov    -0x38(%ebp),%eax
    3503:	83 ec 04             	sub    $0x4,%esp
    3506:	6a 01                	push   $0x1
    3508:	8d 55 9f             	lea    -0x61(%ebp),%edx
    350b:	52                   	push   %edx
    350c:	50                   	push   %eax
    350d:	e8 d1 09 00 00       	call   3ee3 <read>
    3512:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3515:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3519:	8b 45 f0             	mov    -0x10(%ebp),%eax
    351c:	83 f8 09             	cmp    $0x9,%eax
    351f:	0f 86 6c ff ff ff    	jbe    3491 <sbrktest+0x39c>
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    3525:	83 ec 0c             	sub    $0xc,%esp
    3528:	68 00 10 00 00       	push   $0x1000
    352d:	e8 21 0a 00 00       	call   3f53 <sbrk>
    3532:	83 c4 10             	add    $0x10,%esp
    3535:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3538:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    353f:	eb 2b                	jmp    356c <sbrktest+0x477>
    if(pids[i] == -1)
    3541:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3544:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3548:	83 f8 ff             	cmp    $0xffffffff,%eax
    354b:	74 1a                	je     3567 <sbrktest+0x472>
      continue;
    kill(pids[i]);
    354d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3550:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3554:	83 ec 0c             	sub    $0xc,%esp
    3557:	50                   	push   %eax
    3558:	e8 9e 09 00 00       	call   3efb <kill>
    355d:	83 c4 10             	add    $0x10,%esp
    wait();
    3560:	e8 6e 09 00 00       	call   3ed3 <wait>
    3565:	eb 01                	jmp    3568 <sbrktest+0x473>
      continue;
    3567:	90                   	nop
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3568:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    356c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    356f:	83 f8 09             	cmp    $0x9,%eax
    3572:	76 cd                	jbe    3541 <sbrktest+0x44c>
  }
  if(c == (char*)0xffffffff){
    3574:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    3578:	75 1b                	jne    3595 <sbrktest+0x4a0>
    printf(stdout, "failed sbrk leaked memory\n");
    357a:	a1 a8 62 00 00       	mov    0x62a8,%eax
    357f:	83 ec 08             	sub    $0x8,%esp
    3582:	68 5a 59 00 00       	push   $0x595a
    3587:	50                   	push   %eax
    3588:	e8 b1 0a 00 00       	call   403e <printf>
    358d:	83 c4 10             	add    $0x10,%esp
    exit();
    3590:	e8 36 09 00 00       	call   3ecb <exit>
  }

  if(sbrk(0) > oldbrk)
    3595:	83 ec 0c             	sub    $0xc,%esp
    3598:	6a 00                	push   $0x0
    359a:	e8 b4 09 00 00       	call   3f53 <sbrk>
    359f:	83 c4 10             	add    $0x10,%esp
    35a2:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    35a5:	73 20                	jae    35c7 <sbrktest+0x4d2>
    sbrk(-(sbrk(0) - oldbrk));
    35a7:	83 ec 0c             	sub    $0xc,%esp
    35aa:	6a 00                	push   $0x0
    35ac:	e8 a2 09 00 00       	call   3f53 <sbrk>
    35b1:	83 c4 10             	add    $0x10,%esp
    35b4:	89 c2                	mov    %eax,%edx
    35b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    35b9:	29 d0                	sub    %edx,%eax
    35bb:	83 ec 0c             	sub    $0xc,%esp
    35be:	50                   	push   %eax
    35bf:	e8 8f 09 00 00       	call   3f53 <sbrk>
    35c4:	83 c4 10             	add    $0x10,%esp

  printf(stdout, "sbrk test OK\n");
    35c7:	a1 a8 62 00 00       	mov    0x62a8,%eax
    35cc:	83 ec 08             	sub    $0x8,%esp
    35cf:	68 75 59 00 00       	push   $0x5975
    35d4:	50                   	push   %eax
    35d5:	e8 64 0a 00 00       	call   403e <printf>
    35da:	83 c4 10             	add    $0x10,%esp
}
    35dd:	90                   	nop
    35de:	c9                   	leave  
    35df:	c3                   	ret    

000035e0 <validateint>:

void
validateint(int *p)
{
    35e0:	55                   	push   %ebp
    35e1:	89 e5                	mov    %esp,%ebp
    35e3:	53                   	push   %ebx
    35e4:	83 ec 10             	sub    $0x10,%esp
  int res;
  asm("mov %%esp, %%ebx\n\t"
    35e7:	b8 0d 00 00 00       	mov    $0xd,%eax
    35ec:	8b 55 08             	mov    0x8(%ebp),%edx
    35ef:	89 d1                	mov    %edx,%ecx
    35f1:	89 e3                	mov    %esp,%ebx
    35f3:	89 cc                	mov    %ecx,%esp
    35f5:	cd 40                	int    $0x40
    35f7:	89 dc                	mov    %ebx,%esp
    35f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    35fc:	90                   	nop
    35fd:	83 c4 10             	add    $0x10,%esp
    3600:	5b                   	pop    %ebx
    3601:	5d                   	pop    %ebp
    3602:	c3                   	ret    

00003603 <validatetest>:

void
validatetest(void)
{
    3603:	55                   	push   %ebp
    3604:	89 e5                	mov    %esp,%ebp
    3606:	83 ec 18             	sub    $0x18,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    3609:	a1 a8 62 00 00       	mov    0x62a8,%eax
    360e:	83 ec 08             	sub    $0x8,%esp
    3611:	68 83 59 00 00       	push   $0x5983
    3616:	50                   	push   %eax
    3617:	e8 22 0a 00 00       	call   403e <printf>
    361c:	83 c4 10             	add    $0x10,%esp
  hi = 1100*1024;
    361f:	c7 45 f0 00 30 11 00 	movl   $0x113000,-0x10(%ebp)

  for(p = 0; p <= (uint)hi; p += 4096){
    3626:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    362d:	e9 8a 00 00 00       	jmp    36bc <validatetest+0xb9>
    if((pid = fork()) == 0){
    3632:	e8 8c 08 00 00       	call   3ec3 <fork>
    3637:	89 45 ec             	mov    %eax,-0x14(%ebp)
    363a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    363e:	75 14                	jne    3654 <validatetest+0x51>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
    3640:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3643:	83 ec 0c             	sub    $0xc,%esp
    3646:	50                   	push   %eax
    3647:	e8 94 ff ff ff       	call   35e0 <validateint>
    364c:	83 c4 10             	add    $0x10,%esp
      exit();
    364f:	e8 77 08 00 00       	call   3ecb <exit>
    }
    sleep(0);
    3654:	83 ec 0c             	sub    $0xc,%esp
    3657:	6a 00                	push   $0x0
    3659:	e8 fd 08 00 00       	call   3f5b <sleep>
    365e:	83 c4 10             	add    $0x10,%esp
    sleep(0);
    3661:	83 ec 0c             	sub    $0xc,%esp
    3664:	6a 00                	push   $0x0
    3666:	e8 f0 08 00 00       	call   3f5b <sleep>
    366b:	83 c4 10             	add    $0x10,%esp
    kill(pid);
    366e:	83 ec 0c             	sub    $0xc,%esp
    3671:	ff 75 ec             	pushl  -0x14(%ebp)
    3674:	e8 82 08 00 00       	call   3efb <kill>
    3679:	83 c4 10             	add    $0x10,%esp
    wait();
    367c:	e8 52 08 00 00       	call   3ed3 <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    3681:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3684:	83 ec 08             	sub    $0x8,%esp
    3687:	50                   	push   %eax
    3688:	68 92 59 00 00       	push   $0x5992
    368d:	e8 99 08 00 00       	call   3f2b <link>
    3692:	83 c4 10             	add    $0x10,%esp
    3695:	83 f8 ff             	cmp    $0xffffffff,%eax
    3698:	74 1b                	je     36b5 <validatetest+0xb2>
      printf(stdout, "link should not succeed\n");
    369a:	a1 a8 62 00 00       	mov    0x62a8,%eax
    369f:	83 ec 08             	sub    $0x8,%esp
    36a2:	68 9d 59 00 00       	push   $0x599d
    36a7:	50                   	push   %eax
    36a8:	e8 91 09 00 00       	call   403e <printf>
    36ad:	83 c4 10             	add    $0x10,%esp
      exit();
    36b0:	e8 16 08 00 00       	call   3ecb <exit>
  for(p = 0; p <= (uint)hi; p += 4096){
    36b5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    36bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    36bf:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    36c2:	0f 86 6a ff ff ff    	jbe    3632 <validatetest+0x2f>
    }
  }

  printf(stdout, "validate ok\n");
    36c8:	a1 a8 62 00 00       	mov    0x62a8,%eax
    36cd:	83 ec 08             	sub    $0x8,%esp
    36d0:	68 b6 59 00 00       	push   $0x59b6
    36d5:	50                   	push   %eax
    36d6:	e8 63 09 00 00       	call   403e <printf>
    36db:	83 c4 10             	add    $0x10,%esp
}
    36de:	90                   	nop
    36df:	c9                   	leave  
    36e0:	c3                   	ret    

000036e1 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    36e1:	55                   	push   %ebp
    36e2:	89 e5                	mov    %esp,%ebp
    36e4:	83 ec 18             	sub    $0x18,%esp
  int i;

  printf(stdout, "bss test\n");
    36e7:	a1 a8 62 00 00       	mov    0x62a8,%eax
    36ec:	83 ec 08             	sub    $0x8,%esp
    36ef:	68 c3 59 00 00       	push   $0x59c3
    36f4:	50                   	push   %eax
    36f5:	e8 44 09 00 00       	call   403e <printf>
    36fa:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(uninit); i++){
    36fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3704:	eb 2e                	jmp    3734 <bsstest+0x53>
    if(uninit[i] != '\0'){
    3706:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3709:	05 80 63 00 00       	add    $0x6380,%eax
    370e:	0f b6 00             	movzbl (%eax),%eax
    3711:	84 c0                	test   %al,%al
    3713:	74 1b                	je     3730 <bsstest+0x4f>
      printf(stdout, "bss test failed\n");
    3715:	a1 a8 62 00 00       	mov    0x62a8,%eax
    371a:	83 ec 08             	sub    $0x8,%esp
    371d:	68 cd 59 00 00       	push   $0x59cd
    3722:	50                   	push   %eax
    3723:	e8 16 09 00 00       	call   403e <printf>
    3728:	83 c4 10             	add    $0x10,%esp
      exit();
    372b:	e8 9b 07 00 00       	call   3ecb <exit>
  for(i = 0; i < sizeof(uninit); i++){
    3730:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3734:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3737:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    373c:	76 c8                	jbe    3706 <bsstest+0x25>
    }
  }
  printf(stdout, "bss test ok\n");
    373e:	a1 a8 62 00 00       	mov    0x62a8,%eax
    3743:	83 ec 08             	sub    $0x8,%esp
    3746:	68 de 59 00 00       	push   $0x59de
    374b:	50                   	push   %eax
    374c:	e8 ed 08 00 00       	call   403e <printf>
    3751:	83 c4 10             	add    $0x10,%esp
}
    3754:	90                   	nop
    3755:	c9                   	leave  
    3756:	c3                   	ret    

00003757 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    3757:	55                   	push   %ebp
    3758:	89 e5                	mov    %esp,%ebp
    375a:	83 ec 18             	sub    $0x18,%esp
  int pid, fd;

  unlink("bigarg-ok");
    375d:	83 ec 0c             	sub    $0xc,%esp
    3760:	68 eb 59 00 00       	push   $0x59eb
    3765:	e8 b1 07 00 00       	call   3f1b <unlink>
    376a:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    376d:	e8 51 07 00 00       	call   3ec3 <fork>
    3772:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    3775:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3779:	0f 85 97 00 00 00    	jne    3816 <bigargtest+0xbf>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    377f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3786:	eb 12                	jmp    379a <bigargtest+0x43>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    3788:	8b 45 f4             	mov    -0xc(%ebp),%eax
    378b:	c7 04 85 e0 62 00 00 	movl   $0x59f8,0x62e0(,%eax,4)
    3792:	f8 59 00 00 
    for(i = 0; i < MAXARG-1; i++)
    3796:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    379a:	83 7d f4 1e          	cmpl   $0x1e,-0xc(%ebp)
    379e:	7e e8                	jle    3788 <bigargtest+0x31>
    args[MAXARG-1] = 0;
    37a0:	c7 05 5c 63 00 00 00 	movl   $0x0,0x635c
    37a7:	00 00 00 
    printf(stdout, "bigarg test\n");
    37aa:	a1 a8 62 00 00       	mov    0x62a8,%eax
    37af:	83 ec 08             	sub    $0x8,%esp
    37b2:	68 d5 5a 00 00       	push   $0x5ad5
    37b7:	50                   	push   %eax
    37b8:	e8 81 08 00 00       	call   403e <printf>
    37bd:	83 c4 10             	add    $0x10,%esp
    exec("echo", args);
    37c0:	83 ec 08             	sub    $0x8,%esp
    37c3:	68 e0 62 00 00       	push   $0x62e0
    37c8:	68 f4 43 00 00       	push   $0x43f4
    37cd:	e8 31 07 00 00       	call   3f03 <exec>
    37d2:	83 c4 10             	add    $0x10,%esp
    printf(stdout, "bigarg test ok\n");
    37d5:	a1 a8 62 00 00       	mov    0x62a8,%eax
    37da:	83 ec 08             	sub    $0x8,%esp
    37dd:	68 e2 5a 00 00       	push   $0x5ae2
    37e2:	50                   	push   %eax
    37e3:	e8 56 08 00 00       	call   403e <printf>
    37e8:	83 c4 10             	add    $0x10,%esp
    fd = open("bigarg-ok", O_CREATE);
    37eb:	83 ec 08             	sub    $0x8,%esp
    37ee:	68 00 02 00 00       	push   $0x200
    37f3:	68 eb 59 00 00       	push   $0x59eb
    37f8:	e8 0e 07 00 00       	call   3f0b <open>
    37fd:	83 c4 10             	add    $0x10,%esp
    3800:	89 45 ec             	mov    %eax,-0x14(%ebp)
    close(fd);
    3803:	83 ec 0c             	sub    $0xc,%esp
    3806:	ff 75 ec             	pushl  -0x14(%ebp)
    3809:	e8 e5 06 00 00       	call   3ef3 <close>
    380e:	83 c4 10             	add    $0x10,%esp
    exit();
    3811:	e8 b5 06 00 00       	call   3ecb <exit>
  } else if(pid < 0){
    3816:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    381a:	79 1b                	jns    3837 <bigargtest+0xe0>
    printf(stdout, "bigargtest: fork failed\n");
    381c:	a1 a8 62 00 00       	mov    0x62a8,%eax
    3821:	83 ec 08             	sub    $0x8,%esp
    3824:	68 f2 5a 00 00       	push   $0x5af2
    3829:	50                   	push   %eax
    382a:	e8 0f 08 00 00       	call   403e <printf>
    382f:	83 c4 10             	add    $0x10,%esp
    exit();
    3832:	e8 94 06 00 00       	call   3ecb <exit>
  }
  wait();
    3837:	e8 97 06 00 00       	call   3ed3 <wait>
  fd = open("bigarg-ok", 0);
    383c:	83 ec 08             	sub    $0x8,%esp
    383f:	6a 00                	push   $0x0
    3841:	68 eb 59 00 00       	push   $0x59eb
    3846:	e8 c0 06 00 00       	call   3f0b <open>
    384b:	83 c4 10             	add    $0x10,%esp
    384e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    3851:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3855:	79 1b                	jns    3872 <bigargtest+0x11b>
    printf(stdout, "bigarg test failed!\n");
    3857:	a1 a8 62 00 00       	mov    0x62a8,%eax
    385c:	83 ec 08             	sub    $0x8,%esp
    385f:	68 0b 5b 00 00       	push   $0x5b0b
    3864:	50                   	push   %eax
    3865:	e8 d4 07 00 00       	call   403e <printf>
    386a:	83 c4 10             	add    $0x10,%esp
    exit();
    386d:	e8 59 06 00 00       	call   3ecb <exit>
  }
  close(fd);
    3872:	83 ec 0c             	sub    $0xc,%esp
    3875:	ff 75 ec             	pushl  -0x14(%ebp)
    3878:	e8 76 06 00 00       	call   3ef3 <close>
    387d:	83 c4 10             	add    $0x10,%esp
  unlink("bigarg-ok");
    3880:	83 ec 0c             	sub    $0xc,%esp
    3883:	68 eb 59 00 00       	push   $0x59eb
    3888:	e8 8e 06 00 00       	call   3f1b <unlink>
    388d:	83 c4 10             	add    $0x10,%esp
}
    3890:	90                   	nop
    3891:	c9                   	leave  
    3892:	c3                   	ret    

00003893 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    3893:	55                   	push   %ebp
    3894:	89 e5                	mov    %esp,%ebp
    3896:	53                   	push   %ebx
    3897:	83 ec 64             	sub    $0x64,%esp
  int nfiles;
  int fsblocks = 0;
    389a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  printf(1, "fsfull test\n");
    38a1:	83 ec 08             	sub    $0x8,%esp
    38a4:	68 20 5b 00 00       	push   $0x5b20
    38a9:	6a 01                	push   $0x1
    38ab:	e8 8e 07 00 00       	call   403e <printf>
    38b0:	83 c4 10             	add    $0x10,%esp

  for(nfiles = 0; ; nfiles++){
    38b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char name[64];
    name[0] = 'f';
    38ba:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    38be:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    38c1:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    38c6:	89 c8                	mov    %ecx,%eax
    38c8:	f7 ea                	imul   %edx
    38ca:	c1 fa 06             	sar    $0x6,%edx
    38cd:	89 c8                	mov    %ecx,%eax
    38cf:	c1 f8 1f             	sar    $0x1f,%eax
    38d2:	29 c2                	sub    %eax,%edx
    38d4:	89 d0                	mov    %edx,%eax
    38d6:	83 c0 30             	add    $0x30,%eax
    38d9:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    38dc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    38df:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    38e4:	89 d8                	mov    %ebx,%eax
    38e6:	f7 ea                	imul   %edx
    38e8:	c1 fa 06             	sar    $0x6,%edx
    38eb:	89 d8                	mov    %ebx,%eax
    38ed:	c1 f8 1f             	sar    $0x1f,%eax
    38f0:	89 d1                	mov    %edx,%ecx
    38f2:	29 c1                	sub    %eax,%ecx
    38f4:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    38fa:	29 c3                	sub    %eax,%ebx
    38fc:	89 d9                	mov    %ebx,%ecx
    38fe:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3903:	89 c8                	mov    %ecx,%eax
    3905:	f7 ea                	imul   %edx
    3907:	c1 fa 05             	sar    $0x5,%edx
    390a:	89 c8                	mov    %ecx,%eax
    390c:	c1 f8 1f             	sar    $0x1f,%eax
    390f:	29 c2                	sub    %eax,%edx
    3911:	89 d0                	mov    %edx,%eax
    3913:	83 c0 30             	add    $0x30,%eax
    3916:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3919:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    391c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3921:	89 d8                	mov    %ebx,%eax
    3923:	f7 ea                	imul   %edx
    3925:	c1 fa 05             	sar    $0x5,%edx
    3928:	89 d8                	mov    %ebx,%eax
    392a:	c1 f8 1f             	sar    $0x1f,%eax
    392d:	89 d1                	mov    %edx,%ecx
    392f:	29 c1                	sub    %eax,%ecx
    3931:	6b c1 64             	imul   $0x64,%ecx,%eax
    3934:	29 c3                	sub    %eax,%ebx
    3936:	89 d9                	mov    %ebx,%ecx
    3938:	ba 67 66 66 66       	mov    $0x66666667,%edx
    393d:	89 c8                	mov    %ecx,%eax
    393f:	f7 ea                	imul   %edx
    3941:	c1 fa 02             	sar    $0x2,%edx
    3944:	89 c8                	mov    %ecx,%eax
    3946:	c1 f8 1f             	sar    $0x1f,%eax
    3949:	29 c2                	sub    %eax,%edx
    394b:	89 d0                	mov    %edx,%eax
    394d:	83 c0 30             	add    $0x30,%eax
    3950:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3953:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3956:	ba 67 66 66 66       	mov    $0x66666667,%edx
    395b:	89 c8                	mov    %ecx,%eax
    395d:	f7 ea                	imul   %edx
    395f:	c1 fa 02             	sar    $0x2,%edx
    3962:	89 c8                	mov    %ecx,%eax
    3964:	c1 f8 1f             	sar    $0x1f,%eax
    3967:	29 c2                	sub    %eax,%edx
    3969:	89 d0                	mov    %edx,%eax
    396b:	c1 e0 02             	shl    $0x2,%eax
    396e:	01 d0                	add    %edx,%eax
    3970:	01 c0                	add    %eax,%eax
    3972:	29 c1                	sub    %eax,%ecx
    3974:	89 ca                	mov    %ecx,%edx
    3976:	89 d0                	mov    %edx,%eax
    3978:	83 c0 30             	add    $0x30,%eax
    397b:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    397e:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    printf(1, "writing %s\n", name);
    3982:	83 ec 04             	sub    $0x4,%esp
    3985:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3988:	50                   	push   %eax
    3989:	68 2d 5b 00 00       	push   $0x5b2d
    398e:	6a 01                	push   $0x1
    3990:	e8 a9 06 00 00       	call   403e <printf>
    3995:	83 c4 10             	add    $0x10,%esp
    int fd = open(name, O_CREATE|O_RDWR);
    3998:	83 ec 08             	sub    $0x8,%esp
    399b:	68 02 02 00 00       	push   $0x202
    39a0:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    39a3:	50                   	push   %eax
    39a4:	e8 62 05 00 00       	call   3f0b <open>
    39a9:	83 c4 10             	add    $0x10,%esp
    39ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(fd < 0){
    39af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    39b3:	79 18                	jns    39cd <fsfull+0x13a>
      printf(1, "open %s failed\n", name);
    39b5:	83 ec 04             	sub    $0x4,%esp
    39b8:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    39bb:	50                   	push   %eax
    39bc:	68 39 5b 00 00       	push   $0x5b39
    39c1:	6a 01                	push   $0x1
    39c3:	e8 76 06 00 00       	call   403e <printf>
    39c8:	83 c4 10             	add    $0x10,%esp
      break;
    39cb:	eb 6b                	jmp    3a38 <fsfull+0x1a5>
    }
    int total = 0;
    39cd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while(1){
      int cc = write(fd, buf, 512);
    39d4:	83 ec 04             	sub    $0x4,%esp
    39d7:	68 00 02 00 00       	push   $0x200
    39dc:	68 a0 8a 00 00       	push   $0x8aa0
    39e1:	ff 75 e8             	pushl  -0x18(%ebp)
    39e4:	e8 02 05 00 00       	call   3eeb <write>
    39e9:	83 c4 10             	add    $0x10,%esp
    39ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(cc < 512)
    39ef:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%ebp)
    39f6:	7e 0c                	jle    3a04 <fsfull+0x171>
        break;
      total += cc;
    39f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    39fb:	01 45 ec             	add    %eax,-0x14(%ebp)
      fsblocks++;
    39fe:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    while(1){
    3a02:	eb d0                	jmp    39d4 <fsfull+0x141>
        break;
    3a04:	90                   	nop
    }
    printf(1, "wrote %d bytes\n", total);
    3a05:	83 ec 04             	sub    $0x4,%esp
    3a08:	ff 75 ec             	pushl  -0x14(%ebp)
    3a0b:	68 49 5b 00 00       	push   $0x5b49
    3a10:	6a 01                	push   $0x1
    3a12:	e8 27 06 00 00       	call   403e <printf>
    3a17:	83 c4 10             	add    $0x10,%esp
    close(fd);
    3a1a:	83 ec 0c             	sub    $0xc,%esp
    3a1d:	ff 75 e8             	pushl  -0x18(%ebp)
    3a20:	e8 ce 04 00 00       	call   3ef3 <close>
    3a25:	83 c4 10             	add    $0x10,%esp
    if(total == 0)
    3a28:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3a2c:	74 09                	je     3a37 <fsfull+0x1a4>
  for(nfiles = 0; ; nfiles++){
    3a2e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3a32:	e9 83 fe ff ff       	jmp    38ba <fsfull+0x27>
      break;
    3a37:	90                   	nop
  }

  while(nfiles >= 0){
    3a38:	e9 db 00 00 00       	jmp    3b18 <fsfull+0x285>
    char name[64];
    name[0] = 'f';
    3a3d:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    3a41:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3a44:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3a49:	89 c8                	mov    %ecx,%eax
    3a4b:	f7 ea                	imul   %edx
    3a4d:	c1 fa 06             	sar    $0x6,%edx
    3a50:	89 c8                	mov    %ecx,%eax
    3a52:	c1 f8 1f             	sar    $0x1f,%eax
    3a55:	29 c2                	sub    %eax,%edx
    3a57:	89 d0                	mov    %edx,%eax
    3a59:	83 c0 30             	add    $0x30,%eax
    3a5c:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3a5f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3a62:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3a67:	89 d8                	mov    %ebx,%eax
    3a69:	f7 ea                	imul   %edx
    3a6b:	c1 fa 06             	sar    $0x6,%edx
    3a6e:	89 d8                	mov    %ebx,%eax
    3a70:	c1 f8 1f             	sar    $0x1f,%eax
    3a73:	89 d1                	mov    %edx,%ecx
    3a75:	29 c1                	sub    %eax,%ecx
    3a77:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    3a7d:	29 c3                	sub    %eax,%ebx
    3a7f:	89 d9                	mov    %ebx,%ecx
    3a81:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3a86:	89 c8                	mov    %ecx,%eax
    3a88:	f7 ea                	imul   %edx
    3a8a:	c1 fa 05             	sar    $0x5,%edx
    3a8d:	89 c8                	mov    %ecx,%eax
    3a8f:	c1 f8 1f             	sar    $0x1f,%eax
    3a92:	29 c2                	sub    %eax,%edx
    3a94:	89 d0                	mov    %edx,%eax
    3a96:	83 c0 30             	add    $0x30,%eax
    3a99:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3a9c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3a9f:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3aa4:	89 d8                	mov    %ebx,%eax
    3aa6:	f7 ea                	imul   %edx
    3aa8:	c1 fa 05             	sar    $0x5,%edx
    3aab:	89 d8                	mov    %ebx,%eax
    3aad:	c1 f8 1f             	sar    $0x1f,%eax
    3ab0:	89 d1                	mov    %edx,%ecx
    3ab2:	29 c1                	sub    %eax,%ecx
    3ab4:	6b c1 64             	imul   $0x64,%ecx,%eax
    3ab7:	29 c3                	sub    %eax,%ebx
    3ab9:	89 d9                	mov    %ebx,%ecx
    3abb:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3ac0:	89 c8                	mov    %ecx,%eax
    3ac2:	f7 ea                	imul   %edx
    3ac4:	c1 fa 02             	sar    $0x2,%edx
    3ac7:	89 c8                	mov    %ecx,%eax
    3ac9:	c1 f8 1f             	sar    $0x1f,%eax
    3acc:	29 c2                	sub    %eax,%edx
    3ace:	89 d0                	mov    %edx,%eax
    3ad0:	83 c0 30             	add    $0x30,%eax
    3ad3:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3ad6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3ad9:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3ade:	89 c8                	mov    %ecx,%eax
    3ae0:	f7 ea                	imul   %edx
    3ae2:	c1 fa 02             	sar    $0x2,%edx
    3ae5:	89 c8                	mov    %ecx,%eax
    3ae7:	c1 f8 1f             	sar    $0x1f,%eax
    3aea:	29 c2                	sub    %eax,%edx
    3aec:	89 d0                	mov    %edx,%eax
    3aee:	c1 e0 02             	shl    $0x2,%eax
    3af1:	01 d0                	add    %edx,%eax
    3af3:	01 c0                	add    %eax,%eax
    3af5:	29 c1                	sub    %eax,%ecx
    3af7:	89 ca                	mov    %ecx,%edx
    3af9:	89 d0                	mov    %edx,%eax
    3afb:	83 c0 30             	add    $0x30,%eax
    3afe:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3b01:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    unlink(name);
    3b05:	83 ec 0c             	sub    $0xc,%esp
    3b08:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3b0b:	50                   	push   %eax
    3b0c:	e8 0a 04 00 00       	call   3f1b <unlink>
    3b11:	83 c4 10             	add    $0x10,%esp
    nfiles--;
    3b14:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  while(nfiles >= 0){
    3b18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3b1c:	0f 89 1b ff ff ff    	jns    3a3d <fsfull+0x1aa>
  }

  printf(1, "fsfull test finished\n");
    3b22:	83 ec 08             	sub    $0x8,%esp
    3b25:	68 59 5b 00 00       	push   $0x5b59
    3b2a:	6a 01                	push   $0x1
    3b2c:	e8 0d 05 00 00       	call   403e <printf>
    3b31:	83 c4 10             	add    $0x10,%esp
}
    3b34:	90                   	nop
    3b35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3b38:	c9                   	leave  
    3b39:	c3                   	ret    

00003b3a <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    3b3a:	55                   	push   %ebp
    3b3b:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    3b3d:	a1 ac 62 00 00       	mov    0x62ac,%eax
    3b42:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    3b48:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    3b4d:	a3 ac 62 00 00       	mov    %eax,0x62ac
  return randstate;
    3b52:	a1 ac 62 00 00       	mov    0x62ac,%eax
}
    3b57:	5d                   	pop    %ebp
    3b58:	c3                   	ret    

00003b59 <main>:

int
main(int argc, char *argv[])
{
    3b59:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    3b5d:	83 e4 f0             	and    $0xfffffff0,%esp
    3b60:	ff 71 fc             	pushl  -0x4(%ecx)
    3b63:	55                   	push   %ebp
    3b64:	89 e5                	mov    %esp,%ebp
    3b66:	51                   	push   %ecx
    3b67:	83 ec 04             	sub    $0x4,%esp
  printf(1, "usertests starting\n");
    3b6a:	83 ec 08             	sub    $0x8,%esp
    3b6d:	68 6f 5b 00 00       	push   $0x5b6f
    3b72:	6a 01                	push   $0x1
    3b74:	e8 c5 04 00 00       	call   403e <printf>
    3b79:	83 c4 10             	add    $0x10,%esp

  if(open("usertests.ran", 0) >= 0){
    3b7c:	83 ec 08             	sub    $0x8,%esp
    3b7f:	6a 00                	push   $0x0
    3b81:	68 83 5b 00 00       	push   $0x5b83
    3b86:	e8 80 03 00 00       	call   3f0b <open>
    3b8b:	83 c4 10             	add    $0x10,%esp
    3b8e:	85 c0                	test   %eax,%eax
    3b90:	78 17                	js     3ba9 <main+0x50>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    3b92:	83 ec 08             	sub    $0x8,%esp
    3b95:	68 94 5b 00 00       	push   $0x5b94
    3b9a:	6a 01                	push   $0x1
    3b9c:	e8 9d 04 00 00       	call   403e <printf>
    3ba1:	83 c4 10             	add    $0x10,%esp
    exit();
    3ba4:	e8 22 03 00 00       	call   3ecb <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3ba9:	83 ec 08             	sub    $0x8,%esp
    3bac:	68 00 02 00 00       	push   $0x200
    3bb1:	68 83 5b 00 00       	push   $0x5b83
    3bb6:	e8 50 03 00 00       	call   3f0b <open>
    3bbb:	83 c4 10             	add    $0x10,%esp
    3bbe:	83 ec 0c             	sub    $0xc,%esp
    3bc1:	50                   	push   %eax
    3bc2:	e8 2c 03 00 00       	call   3ef3 <close>
    3bc7:	83 c4 10             	add    $0x10,%esp

  createdelete();
    3bca:	e8 db d6 ff ff       	call   12aa <createdelete>
  linkunlink();
    3bcf:	e8 fc e0 ff ff       	call   1cd0 <linkunlink>
  concreate();
    3bd4:	e8 47 dd ff ff       	call   1920 <concreate>
  fourfiles();
    3bd9:	e8 7b d4 ff ff       	call   1059 <fourfiles>
  sharedfd();
    3bde:	e8 93 d2 ff ff       	call   e76 <sharedfd>

  bigargtest();
    3be3:	e8 6f fb ff ff       	call   3757 <bigargtest>
  bigwrite();
    3be8:	e8 d5 ea ff ff       	call   26c2 <bigwrite>
  bigargtest();
    3bed:	e8 65 fb ff ff       	call   3757 <bigargtest>
  bsstest();
    3bf2:	e8 ea fa ff ff       	call   36e1 <bsstest>
  sbrktest();
    3bf7:	e8 f9 f4 ff ff       	call   30f5 <sbrktest>
  validatetest();
    3bfc:	e8 02 fa ff ff       	call   3603 <validatetest>

  opentest();
    3c01:	e8 f9 c6 ff ff       	call   2ff <opentest>
  writetest();
    3c06:	e8 a3 c7 ff ff       	call   3ae <writetest>
  writetest1();
    3c0b:	e8 ae c9 ff ff       	call   5be <writetest1>
  createtest();
    3c10:	e8 a5 cb ff ff       	call   7ba <createtest>

  openiputtest();
    3c15:	e8 d6 c5 ff ff       	call   1f0 <openiputtest>
  exitiputtest();
    3c1a:	e8 d2 c4 ff ff       	call   f1 <exitiputtest>
  iputtest();
    3c1f:	e8 dc c3 ff ff       	call   0 <iputtest>

  mem();
    3c24:	e8 5c d1 ff ff       	call   d85 <mem>
  pipe1();
    3c29:	e8 93 cd ff ff       	call   9c1 <pipe1>
  preempt();
    3c2e:	e8 77 cf ff ff       	call   baa <preempt>
  exitwait();
    3c33:	e8 d5 d0 ff ff       	call   d0d <exitwait>

  rmdot();
    3c38:	e8 f7 ee ff ff       	call   2b34 <rmdot>
  fourteen();
    3c3d:	e8 96 ed ff ff       	call   29d8 <fourteen>
  bigfile();
    3c42:	e8 79 eb ff ff       	call   27c0 <bigfile>
  subdir();
    3c47:	e8 32 e3 ff ff       	call   1f7e <subdir>
  linktest();
    3c4c:	e8 8d da ff ff       	call   16de <linktest>
  unlinkread();
    3c51:	e8 c6 d8 ff ff       	call   151c <unlinkread>
  dirfile();
    3c56:	e8 5e f0 ff ff       	call   2cb9 <dirfile>
  iref();
    3c5b:	e8 91 f2 ff ff       	call   2ef1 <iref>
  forktest();
    3c60:	e8 c6 f3 ff ff       	call   302b <forktest>
  bigdir(); // slow
    3c65:	e8 9f e1 ff ff       	call   1e09 <bigdir>
  exectest();
    3c6a:	e8 ff cc ff ff       	call   96e <exectest>

  exit();
    3c6f:	e8 57 02 00 00       	call   3ecb <exit>

00003c74 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    3c74:	55                   	push   %ebp
    3c75:	89 e5                	mov    %esp,%ebp
    3c77:	57                   	push   %edi
    3c78:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    3c79:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3c7c:	8b 55 10             	mov    0x10(%ebp),%edx
    3c7f:	8b 45 0c             	mov    0xc(%ebp),%eax
    3c82:	89 cb                	mov    %ecx,%ebx
    3c84:	89 df                	mov    %ebx,%edi
    3c86:	89 d1                	mov    %edx,%ecx
    3c88:	fc                   	cld    
    3c89:	f3 aa                	rep stos %al,%es:(%edi)
    3c8b:	89 ca                	mov    %ecx,%edx
    3c8d:	89 fb                	mov    %edi,%ebx
    3c8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
    3c92:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    3c95:	90                   	nop
    3c96:	5b                   	pop    %ebx
    3c97:	5f                   	pop    %edi
    3c98:	5d                   	pop    %ebp
    3c99:	c3                   	ret    

00003c9a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    3c9a:	55                   	push   %ebp
    3c9b:	89 e5                	mov    %esp,%ebp
    3c9d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    3ca0:	8b 45 08             	mov    0x8(%ebp),%eax
    3ca3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    3ca6:	90                   	nop
    3ca7:	8b 55 0c             	mov    0xc(%ebp),%edx
    3caa:	8d 42 01             	lea    0x1(%edx),%eax
    3cad:	89 45 0c             	mov    %eax,0xc(%ebp)
    3cb0:	8b 45 08             	mov    0x8(%ebp),%eax
    3cb3:	8d 48 01             	lea    0x1(%eax),%ecx
    3cb6:	89 4d 08             	mov    %ecx,0x8(%ebp)
    3cb9:	0f b6 12             	movzbl (%edx),%edx
    3cbc:	88 10                	mov    %dl,(%eax)
    3cbe:	0f b6 00             	movzbl (%eax),%eax
    3cc1:	84 c0                	test   %al,%al
    3cc3:	75 e2                	jne    3ca7 <strcpy+0xd>
    ;
  return os;
    3cc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3cc8:	c9                   	leave  
    3cc9:	c3                   	ret    

00003cca <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3cca:	55                   	push   %ebp
    3ccb:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    3ccd:	eb 08                	jmp    3cd7 <strcmp+0xd>
    p++, q++;
    3ccf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3cd3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
    3cd7:	8b 45 08             	mov    0x8(%ebp),%eax
    3cda:	0f b6 00             	movzbl (%eax),%eax
    3cdd:	84 c0                	test   %al,%al
    3cdf:	74 10                	je     3cf1 <strcmp+0x27>
    3ce1:	8b 45 08             	mov    0x8(%ebp),%eax
    3ce4:	0f b6 10             	movzbl (%eax),%edx
    3ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
    3cea:	0f b6 00             	movzbl (%eax),%eax
    3ced:	38 c2                	cmp    %al,%dl
    3cef:	74 de                	je     3ccf <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
    3cf1:	8b 45 08             	mov    0x8(%ebp),%eax
    3cf4:	0f b6 00             	movzbl (%eax),%eax
    3cf7:	0f b6 d0             	movzbl %al,%edx
    3cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
    3cfd:	0f b6 00             	movzbl (%eax),%eax
    3d00:	0f b6 c0             	movzbl %al,%eax
    3d03:	29 c2                	sub    %eax,%edx
    3d05:	89 d0                	mov    %edx,%eax
}
    3d07:	5d                   	pop    %ebp
    3d08:	c3                   	ret    

00003d09 <strlen>:

uint
strlen(char *s)
{
    3d09:	55                   	push   %ebp
    3d0a:	89 e5                	mov    %esp,%ebp
    3d0c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    3d0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    3d16:	eb 04                	jmp    3d1c <strlen+0x13>
    3d18:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    3d1c:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3d1f:	8b 45 08             	mov    0x8(%ebp),%eax
    3d22:	01 d0                	add    %edx,%eax
    3d24:	0f b6 00             	movzbl (%eax),%eax
    3d27:	84 c0                	test   %al,%al
    3d29:	75 ed                	jne    3d18 <strlen+0xf>
    ;
  return n;
    3d2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3d2e:	c9                   	leave  
    3d2f:	c3                   	ret    

00003d30 <memset>:

void*
memset(void *dst, int c, uint n)
{
    3d30:	55                   	push   %ebp
    3d31:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    3d33:	8b 45 10             	mov    0x10(%ebp),%eax
    3d36:	50                   	push   %eax
    3d37:	ff 75 0c             	pushl  0xc(%ebp)
    3d3a:	ff 75 08             	pushl  0x8(%ebp)
    3d3d:	e8 32 ff ff ff       	call   3c74 <stosb>
    3d42:	83 c4 0c             	add    $0xc,%esp
  return dst;
    3d45:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3d48:	c9                   	leave  
    3d49:	c3                   	ret    

00003d4a <strchr>:

char*
strchr(const char *s, char c)
{
    3d4a:	55                   	push   %ebp
    3d4b:	89 e5                	mov    %esp,%ebp
    3d4d:	83 ec 04             	sub    $0x4,%esp
    3d50:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d53:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    3d56:	eb 14                	jmp    3d6c <strchr+0x22>
    if(*s == c)
    3d58:	8b 45 08             	mov    0x8(%ebp),%eax
    3d5b:	0f b6 00             	movzbl (%eax),%eax
    3d5e:	38 45 fc             	cmp    %al,-0x4(%ebp)
    3d61:	75 05                	jne    3d68 <strchr+0x1e>
      return (char*)s;
    3d63:	8b 45 08             	mov    0x8(%ebp),%eax
    3d66:	eb 13                	jmp    3d7b <strchr+0x31>
  for(; *s; s++)
    3d68:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3d6c:	8b 45 08             	mov    0x8(%ebp),%eax
    3d6f:	0f b6 00             	movzbl (%eax),%eax
    3d72:	84 c0                	test   %al,%al
    3d74:	75 e2                	jne    3d58 <strchr+0xe>
  return 0;
    3d76:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3d7b:	c9                   	leave  
    3d7c:	c3                   	ret    

00003d7d <gets>:

char*
gets(char *buf, int max)
{
    3d7d:	55                   	push   %ebp
    3d7e:	89 e5                	mov    %esp,%ebp
    3d80:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3d83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3d8a:	eb 42                	jmp    3dce <gets+0x51>
    cc = read(0, &c, 1);
    3d8c:	83 ec 04             	sub    $0x4,%esp
    3d8f:	6a 01                	push   $0x1
    3d91:	8d 45 ef             	lea    -0x11(%ebp),%eax
    3d94:	50                   	push   %eax
    3d95:	6a 00                	push   $0x0
    3d97:	e8 47 01 00 00       	call   3ee3 <read>
    3d9c:	83 c4 10             	add    $0x10,%esp
    3d9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    3da2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3da6:	7e 33                	jle    3ddb <gets+0x5e>
      break;
    buf[i++] = c;
    3da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3dab:	8d 50 01             	lea    0x1(%eax),%edx
    3dae:	89 55 f4             	mov    %edx,-0xc(%ebp)
    3db1:	89 c2                	mov    %eax,%edx
    3db3:	8b 45 08             	mov    0x8(%ebp),%eax
    3db6:	01 c2                	add    %eax,%edx
    3db8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3dbc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    3dbe:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3dc2:	3c 0a                	cmp    $0xa,%al
    3dc4:	74 16                	je     3ddc <gets+0x5f>
    3dc6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3dca:	3c 0d                	cmp    $0xd,%al
    3dcc:	74 0e                	je     3ddc <gets+0x5f>
  for(i=0; i+1 < max; ){
    3dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3dd1:	83 c0 01             	add    $0x1,%eax
    3dd4:	39 45 0c             	cmp    %eax,0xc(%ebp)
    3dd7:	7f b3                	jg     3d8c <gets+0xf>
    3dd9:	eb 01                	jmp    3ddc <gets+0x5f>
      break;
    3ddb:	90                   	nop
      break;
  }
  buf[i] = '\0';
    3ddc:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3ddf:	8b 45 08             	mov    0x8(%ebp),%eax
    3de2:	01 d0                	add    %edx,%eax
    3de4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    3de7:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3dea:	c9                   	leave  
    3deb:	c3                   	ret    

00003dec <stat>:

int
stat(char *n, struct stat *st)
{
    3dec:	55                   	push   %ebp
    3ded:	89 e5                	mov    %esp,%ebp
    3def:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3df2:	83 ec 08             	sub    $0x8,%esp
    3df5:	6a 00                	push   $0x0
    3df7:	ff 75 08             	pushl  0x8(%ebp)
    3dfa:	e8 0c 01 00 00       	call   3f0b <open>
    3dff:	83 c4 10             	add    $0x10,%esp
    3e02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    3e05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3e09:	79 07                	jns    3e12 <stat+0x26>
    return -1;
    3e0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    3e10:	eb 25                	jmp    3e37 <stat+0x4b>
  r = fstat(fd, st);
    3e12:	83 ec 08             	sub    $0x8,%esp
    3e15:	ff 75 0c             	pushl  0xc(%ebp)
    3e18:	ff 75 f4             	pushl  -0xc(%ebp)
    3e1b:	e8 03 01 00 00       	call   3f23 <fstat>
    3e20:	83 c4 10             	add    $0x10,%esp
    3e23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    3e26:	83 ec 0c             	sub    $0xc,%esp
    3e29:	ff 75 f4             	pushl  -0xc(%ebp)
    3e2c:	e8 c2 00 00 00       	call   3ef3 <close>
    3e31:	83 c4 10             	add    $0x10,%esp
  return r;
    3e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    3e37:	c9                   	leave  
    3e38:	c3                   	ret    

00003e39 <atoi>:

int
atoi(const char *s)
{
    3e39:	55                   	push   %ebp
    3e3a:	89 e5                	mov    %esp,%ebp
    3e3c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    3e3f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    3e46:	eb 25                	jmp    3e6d <atoi+0x34>
    n = n*10 + *s++ - '0';
    3e48:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3e4b:	89 d0                	mov    %edx,%eax
    3e4d:	c1 e0 02             	shl    $0x2,%eax
    3e50:	01 d0                	add    %edx,%eax
    3e52:	01 c0                	add    %eax,%eax
    3e54:	89 c1                	mov    %eax,%ecx
    3e56:	8b 45 08             	mov    0x8(%ebp),%eax
    3e59:	8d 50 01             	lea    0x1(%eax),%edx
    3e5c:	89 55 08             	mov    %edx,0x8(%ebp)
    3e5f:	0f b6 00             	movzbl (%eax),%eax
    3e62:	0f be c0             	movsbl %al,%eax
    3e65:	01 c8                	add    %ecx,%eax
    3e67:	83 e8 30             	sub    $0x30,%eax
    3e6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    3e6d:	8b 45 08             	mov    0x8(%ebp),%eax
    3e70:	0f b6 00             	movzbl (%eax),%eax
    3e73:	3c 2f                	cmp    $0x2f,%al
    3e75:	7e 0a                	jle    3e81 <atoi+0x48>
    3e77:	8b 45 08             	mov    0x8(%ebp),%eax
    3e7a:	0f b6 00             	movzbl (%eax),%eax
    3e7d:	3c 39                	cmp    $0x39,%al
    3e7f:	7e c7                	jle    3e48 <atoi+0xf>
  return n;
    3e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3e84:	c9                   	leave  
    3e85:	c3                   	ret    

00003e86 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    3e86:	55                   	push   %ebp
    3e87:	89 e5                	mov    %esp,%ebp
    3e89:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    3e8c:	8b 45 08             	mov    0x8(%ebp),%eax
    3e8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    3e92:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e95:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    3e98:	eb 17                	jmp    3eb1 <memmove+0x2b>
    *dst++ = *src++;
    3e9a:	8b 55 f8             	mov    -0x8(%ebp),%edx
    3e9d:	8d 42 01             	lea    0x1(%edx),%eax
    3ea0:	89 45 f8             	mov    %eax,-0x8(%ebp)
    3ea3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3ea6:	8d 48 01             	lea    0x1(%eax),%ecx
    3ea9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
    3eac:	0f b6 12             	movzbl (%edx),%edx
    3eaf:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
    3eb1:	8b 45 10             	mov    0x10(%ebp),%eax
    3eb4:	8d 50 ff             	lea    -0x1(%eax),%edx
    3eb7:	89 55 10             	mov    %edx,0x10(%ebp)
    3eba:	85 c0                	test   %eax,%eax
    3ebc:	7f dc                	jg     3e9a <memmove+0x14>
  return vdst;
    3ebe:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3ec1:	c9                   	leave  
    3ec2:	c3                   	ret    

00003ec3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    3ec3:	b8 01 00 00 00       	mov    $0x1,%eax
    3ec8:	cd 40                	int    $0x40
    3eca:	c3                   	ret    

00003ecb <exit>:
SYSCALL(exit)
    3ecb:	b8 02 00 00 00       	mov    $0x2,%eax
    3ed0:	cd 40                	int    $0x40
    3ed2:	c3                   	ret    

00003ed3 <wait>:
SYSCALL(wait)
    3ed3:	b8 03 00 00 00       	mov    $0x3,%eax
    3ed8:	cd 40                	int    $0x40
    3eda:	c3                   	ret    

00003edb <pipe>:
SYSCALL(pipe)
    3edb:	b8 04 00 00 00       	mov    $0x4,%eax
    3ee0:	cd 40                	int    $0x40
    3ee2:	c3                   	ret    

00003ee3 <read>:
SYSCALL(read)
    3ee3:	b8 05 00 00 00       	mov    $0x5,%eax
    3ee8:	cd 40                	int    $0x40
    3eea:	c3                   	ret    

00003eeb <write>:
SYSCALL(write)
    3eeb:	b8 10 00 00 00       	mov    $0x10,%eax
    3ef0:	cd 40                	int    $0x40
    3ef2:	c3                   	ret    

00003ef3 <close>:
SYSCALL(close)
    3ef3:	b8 15 00 00 00       	mov    $0x15,%eax
    3ef8:	cd 40                	int    $0x40
    3efa:	c3                   	ret    

00003efb <kill>:
SYSCALL(kill)
    3efb:	b8 06 00 00 00       	mov    $0x6,%eax
    3f00:	cd 40                	int    $0x40
    3f02:	c3                   	ret    

00003f03 <exec>:
SYSCALL(exec)
    3f03:	b8 07 00 00 00       	mov    $0x7,%eax
    3f08:	cd 40                	int    $0x40
    3f0a:	c3                   	ret    

00003f0b <open>:
SYSCALL(open)
    3f0b:	b8 0f 00 00 00       	mov    $0xf,%eax
    3f10:	cd 40                	int    $0x40
    3f12:	c3                   	ret    

00003f13 <mknod>:
SYSCALL(mknod)
    3f13:	b8 11 00 00 00       	mov    $0x11,%eax
    3f18:	cd 40                	int    $0x40
    3f1a:	c3                   	ret    

00003f1b <unlink>:
SYSCALL(unlink)
    3f1b:	b8 12 00 00 00       	mov    $0x12,%eax
    3f20:	cd 40                	int    $0x40
    3f22:	c3                   	ret    

00003f23 <fstat>:
SYSCALL(fstat)
    3f23:	b8 08 00 00 00       	mov    $0x8,%eax
    3f28:	cd 40                	int    $0x40
    3f2a:	c3                   	ret    

00003f2b <link>:
SYSCALL(link)
    3f2b:	b8 13 00 00 00       	mov    $0x13,%eax
    3f30:	cd 40                	int    $0x40
    3f32:	c3                   	ret    

00003f33 <mkdir>:
SYSCALL(mkdir)
    3f33:	b8 14 00 00 00       	mov    $0x14,%eax
    3f38:	cd 40                	int    $0x40
    3f3a:	c3                   	ret    

00003f3b <chdir>:
SYSCALL(chdir)
    3f3b:	b8 09 00 00 00       	mov    $0x9,%eax
    3f40:	cd 40                	int    $0x40
    3f42:	c3                   	ret    

00003f43 <dup>:
SYSCALL(dup)
    3f43:	b8 0a 00 00 00       	mov    $0xa,%eax
    3f48:	cd 40                	int    $0x40
    3f4a:	c3                   	ret    

00003f4b <getpid>:
SYSCALL(getpid)
    3f4b:	b8 0b 00 00 00       	mov    $0xb,%eax
    3f50:	cd 40                	int    $0x40
    3f52:	c3                   	ret    

00003f53 <sbrk>:
SYSCALL(sbrk)
    3f53:	b8 0c 00 00 00       	mov    $0xc,%eax
    3f58:	cd 40                	int    $0x40
    3f5a:	c3                   	ret    

00003f5b <sleep>:
SYSCALL(sleep)
    3f5b:	b8 0d 00 00 00       	mov    $0xd,%eax
    3f60:	cd 40                	int    $0x40
    3f62:	c3                   	ret    

00003f63 <uptime>:
SYSCALL(uptime)
    3f63:	b8 0e 00 00 00       	mov    $0xe,%eax
    3f68:	cd 40                	int    $0x40
    3f6a:	c3                   	ret    

00003f6b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    3f6b:	55                   	push   %ebp
    3f6c:	89 e5                	mov    %esp,%ebp
    3f6e:	83 ec 18             	sub    $0x18,%esp
    3f71:	8b 45 0c             	mov    0xc(%ebp),%eax
    3f74:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    3f77:	83 ec 04             	sub    $0x4,%esp
    3f7a:	6a 01                	push   $0x1
    3f7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
    3f7f:	50                   	push   %eax
    3f80:	ff 75 08             	pushl  0x8(%ebp)
    3f83:	e8 63 ff ff ff       	call   3eeb <write>
    3f88:	83 c4 10             	add    $0x10,%esp
}
    3f8b:	90                   	nop
    3f8c:	c9                   	leave  
    3f8d:	c3                   	ret    

00003f8e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    3f8e:	55                   	push   %ebp
    3f8f:	89 e5                	mov    %esp,%ebp
    3f91:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    3f94:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    3f9b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    3f9f:	74 17                	je     3fb8 <printint+0x2a>
    3fa1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    3fa5:	79 11                	jns    3fb8 <printint+0x2a>
    neg = 1;
    3fa7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    3fae:	8b 45 0c             	mov    0xc(%ebp),%eax
    3fb1:	f7 d8                	neg    %eax
    3fb3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3fb6:	eb 06                	jmp    3fbe <printint+0x30>
  } else {
    x = xx;
    3fb8:	8b 45 0c             	mov    0xc(%ebp),%eax
    3fbb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    3fbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    3fc5:	8b 4d 10             	mov    0x10(%ebp),%ecx
    3fc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3fcb:	ba 00 00 00 00       	mov    $0x0,%edx
    3fd0:	f7 f1                	div    %ecx
    3fd2:	89 d1                	mov    %edx,%ecx
    3fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3fd7:	8d 50 01             	lea    0x1(%eax),%edx
    3fda:	89 55 f4             	mov    %edx,-0xc(%ebp)
    3fdd:	0f b6 91 b0 62 00 00 	movzbl 0x62b0(%ecx),%edx
    3fe4:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
    3fe8:	8b 4d 10             	mov    0x10(%ebp),%ecx
    3feb:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3fee:	ba 00 00 00 00       	mov    $0x0,%edx
    3ff3:	f7 f1                	div    %ecx
    3ff5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3ff8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3ffc:	75 c7                	jne    3fc5 <printint+0x37>
  if(neg)
    3ffe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4002:	74 2d                	je     4031 <printint+0xa3>
    buf[i++] = '-';
    4004:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4007:	8d 50 01             	lea    0x1(%eax),%edx
    400a:	89 55 f4             	mov    %edx,-0xc(%ebp)
    400d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    4012:	eb 1d                	jmp    4031 <printint+0xa3>
    putc(fd, buf[i]);
    4014:	8d 55 dc             	lea    -0x24(%ebp),%edx
    4017:	8b 45 f4             	mov    -0xc(%ebp),%eax
    401a:	01 d0                	add    %edx,%eax
    401c:	0f b6 00             	movzbl (%eax),%eax
    401f:	0f be c0             	movsbl %al,%eax
    4022:	83 ec 08             	sub    $0x8,%esp
    4025:	50                   	push   %eax
    4026:	ff 75 08             	pushl  0x8(%ebp)
    4029:	e8 3d ff ff ff       	call   3f6b <putc>
    402e:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
    4031:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    4035:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4039:	79 d9                	jns    4014 <printint+0x86>
}
    403b:	90                   	nop
    403c:	c9                   	leave  
    403d:	c3                   	ret    

0000403e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    403e:	55                   	push   %ebp
    403f:	89 e5                	mov    %esp,%ebp
    4041:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    4044:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    404b:	8d 45 0c             	lea    0xc(%ebp),%eax
    404e:	83 c0 04             	add    $0x4,%eax
    4051:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    4054:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    405b:	e9 59 01 00 00       	jmp    41b9 <printf+0x17b>
    c = fmt[i] & 0xff;
    4060:	8b 55 0c             	mov    0xc(%ebp),%edx
    4063:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4066:	01 d0                	add    %edx,%eax
    4068:	0f b6 00             	movzbl (%eax),%eax
    406b:	0f be c0             	movsbl %al,%eax
    406e:	25 ff 00 00 00       	and    $0xff,%eax
    4073:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    4076:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    407a:	75 2c                	jne    40a8 <printf+0x6a>
      if(c == '%'){
    407c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    4080:	75 0c                	jne    408e <printf+0x50>
        state = '%';
    4082:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    4089:	e9 27 01 00 00       	jmp    41b5 <printf+0x177>
      } else {
        putc(fd, c);
    408e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4091:	0f be c0             	movsbl %al,%eax
    4094:	83 ec 08             	sub    $0x8,%esp
    4097:	50                   	push   %eax
    4098:	ff 75 08             	pushl  0x8(%ebp)
    409b:	e8 cb fe ff ff       	call   3f6b <putc>
    40a0:	83 c4 10             	add    $0x10,%esp
    40a3:	e9 0d 01 00 00       	jmp    41b5 <printf+0x177>
      }
    } else if(state == '%'){
    40a8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    40ac:	0f 85 03 01 00 00    	jne    41b5 <printf+0x177>
      if(c == 'd'){
    40b2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    40b6:	75 1e                	jne    40d6 <printf+0x98>
        printint(fd, *ap, 10, 1);
    40b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
    40bb:	8b 00                	mov    (%eax),%eax
    40bd:	6a 01                	push   $0x1
    40bf:	6a 0a                	push   $0xa
    40c1:	50                   	push   %eax
    40c2:	ff 75 08             	pushl  0x8(%ebp)
    40c5:	e8 c4 fe ff ff       	call   3f8e <printint>
    40ca:	83 c4 10             	add    $0x10,%esp
        ap++;
    40cd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    40d1:	e9 d8 00 00 00       	jmp    41ae <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    40d6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    40da:	74 06                	je     40e2 <printf+0xa4>
    40dc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    40e0:	75 1e                	jne    4100 <printf+0xc2>
        printint(fd, *ap, 16, 0);
    40e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    40e5:	8b 00                	mov    (%eax),%eax
    40e7:	6a 00                	push   $0x0
    40e9:	6a 10                	push   $0x10
    40eb:	50                   	push   %eax
    40ec:	ff 75 08             	pushl  0x8(%ebp)
    40ef:	e8 9a fe ff ff       	call   3f8e <printint>
    40f4:	83 c4 10             	add    $0x10,%esp
        ap++;
    40f7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    40fb:	e9 ae 00 00 00       	jmp    41ae <printf+0x170>
      } else if(c == 's'){
    4100:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    4104:	75 43                	jne    4149 <printf+0x10b>
        s = (char*)*ap;
    4106:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4109:	8b 00                	mov    (%eax),%eax
    410b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    410e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    4112:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4116:	75 25                	jne    413d <printf+0xff>
          s = "(null)";
    4118:	c7 45 f4 be 5b 00 00 	movl   $0x5bbe,-0xc(%ebp)
        while(*s != 0){
    411f:	eb 1c                	jmp    413d <printf+0xff>
          putc(fd, *s);
    4121:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4124:	0f b6 00             	movzbl (%eax),%eax
    4127:	0f be c0             	movsbl %al,%eax
    412a:	83 ec 08             	sub    $0x8,%esp
    412d:	50                   	push   %eax
    412e:	ff 75 08             	pushl  0x8(%ebp)
    4131:	e8 35 fe ff ff       	call   3f6b <putc>
    4136:	83 c4 10             	add    $0x10,%esp
          s++;
    4139:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
    413d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4140:	0f b6 00             	movzbl (%eax),%eax
    4143:	84 c0                	test   %al,%al
    4145:	75 da                	jne    4121 <printf+0xe3>
    4147:	eb 65                	jmp    41ae <printf+0x170>
        }
      } else if(c == 'c'){
    4149:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    414d:	75 1d                	jne    416c <printf+0x12e>
        putc(fd, *ap);
    414f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4152:	8b 00                	mov    (%eax),%eax
    4154:	0f be c0             	movsbl %al,%eax
    4157:	83 ec 08             	sub    $0x8,%esp
    415a:	50                   	push   %eax
    415b:	ff 75 08             	pushl  0x8(%ebp)
    415e:	e8 08 fe ff ff       	call   3f6b <putc>
    4163:	83 c4 10             	add    $0x10,%esp
        ap++;
    4166:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    416a:	eb 42                	jmp    41ae <printf+0x170>
      } else if(c == '%'){
    416c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    4170:	75 17                	jne    4189 <printf+0x14b>
        putc(fd, c);
    4172:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4175:	0f be c0             	movsbl %al,%eax
    4178:	83 ec 08             	sub    $0x8,%esp
    417b:	50                   	push   %eax
    417c:	ff 75 08             	pushl  0x8(%ebp)
    417f:	e8 e7 fd ff ff       	call   3f6b <putc>
    4184:	83 c4 10             	add    $0x10,%esp
    4187:	eb 25                	jmp    41ae <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    4189:	83 ec 08             	sub    $0x8,%esp
    418c:	6a 25                	push   $0x25
    418e:	ff 75 08             	pushl  0x8(%ebp)
    4191:	e8 d5 fd ff ff       	call   3f6b <putc>
    4196:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    4199:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    419c:	0f be c0             	movsbl %al,%eax
    419f:	83 ec 08             	sub    $0x8,%esp
    41a2:	50                   	push   %eax
    41a3:	ff 75 08             	pushl  0x8(%ebp)
    41a6:	e8 c0 fd ff ff       	call   3f6b <putc>
    41ab:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    41ae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
    41b5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    41b9:	8b 55 0c             	mov    0xc(%ebp),%edx
    41bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    41bf:	01 d0                	add    %edx,%eax
    41c1:	0f b6 00             	movzbl (%eax),%eax
    41c4:	84 c0                	test   %al,%al
    41c6:	0f 85 94 fe ff ff    	jne    4060 <printf+0x22>
    }
  }
}
    41cc:	90                   	nop
    41cd:	c9                   	leave  
    41ce:	c3                   	ret    

000041cf <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    41cf:	55                   	push   %ebp
    41d0:	89 e5                	mov    %esp,%ebp
    41d2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    41d5:	8b 45 08             	mov    0x8(%ebp),%eax
    41d8:	83 e8 08             	sub    $0x8,%eax
    41db:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    41de:	a1 68 63 00 00       	mov    0x6368,%eax
    41e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    41e6:	eb 24                	jmp    420c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    41e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    41eb:	8b 00                	mov    (%eax),%eax
    41ed:	39 45 fc             	cmp    %eax,-0x4(%ebp)
    41f0:	72 12                	jb     4204 <free+0x35>
    41f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    41f5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    41f8:	77 24                	ja     421e <free+0x4f>
    41fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
    41fd:	8b 00                	mov    (%eax),%eax
    41ff:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    4202:	72 1a                	jb     421e <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4204:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4207:	8b 00                	mov    (%eax),%eax
    4209:	89 45 fc             	mov    %eax,-0x4(%ebp)
    420c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    420f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4212:	76 d4                	jbe    41e8 <free+0x19>
    4214:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4217:	8b 00                	mov    (%eax),%eax
    4219:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    421c:	73 ca                	jae    41e8 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    421e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4221:	8b 40 04             	mov    0x4(%eax),%eax
    4224:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    422b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    422e:	01 c2                	add    %eax,%edx
    4230:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4233:	8b 00                	mov    (%eax),%eax
    4235:	39 c2                	cmp    %eax,%edx
    4237:	75 24                	jne    425d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    4239:	8b 45 f8             	mov    -0x8(%ebp),%eax
    423c:	8b 50 04             	mov    0x4(%eax),%edx
    423f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4242:	8b 00                	mov    (%eax),%eax
    4244:	8b 40 04             	mov    0x4(%eax),%eax
    4247:	01 c2                	add    %eax,%edx
    4249:	8b 45 f8             	mov    -0x8(%ebp),%eax
    424c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    424f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4252:	8b 00                	mov    (%eax),%eax
    4254:	8b 10                	mov    (%eax),%edx
    4256:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4259:	89 10                	mov    %edx,(%eax)
    425b:	eb 0a                	jmp    4267 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    425d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4260:	8b 10                	mov    (%eax),%edx
    4262:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4265:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    4267:	8b 45 fc             	mov    -0x4(%ebp),%eax
    426a:	8b 40 04             	mov    0x4(%eax),%eax
    426d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    4274:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4277:	01 d0                	add    %edx,%eax
    4279:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    427c:	75 20                	jne    429e <free+0xcf>
    p->s.size += bp->s.size;
    427e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4281:	8b 50 04             	mov    0x4(%eax),%edx
    4284:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4287:	8b 40 04             	mov    0x4(%eax),%eax
    428a:	01 c2                	add    %eax,%edx
    428c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    428f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    4292:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4295:	8b 10                	mov    (%eax),%edx
    4297:	8b 45 fc             	mov    -0x4(%ebp),%eax
    429a:	89 10                	mov    %edx,(%eax)
    429c:	eb 08                	jmp    42a6 <free+0xd7>
  } else
    p->s.ptr = bp;
    429e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42a1:	8b 55 f8             	mov    -0x8(%ebp),%edx
    42a4:	89 10                	mov    %edx,(%eax)
  freep = p;
    42a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42a9:	a3 68 63 00 00       	mov    %eax,0x6368
}
    42ae:	90                   	nop
    42af:	c9                   	leave  
    42b0:	c3                   	ret    

000042b1 <morecore>:

static Header*
morecore(uint nu)
{
    42b1:	55                   	push   %ebp
    42b2:	89 e5                	mov    %esp,%ebp
    42b4:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    42b7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    42be:	77 07                	ja     42c7 <morecore+0x16>
    nu = 4096;
    42c0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    42c7:	8b 45 08             	mov    0x8(%ebp),%eax
    42ca:	c1 e0 03             	shl    $0x3,%eax
    42cd:	83 ec 0c             	sub    $0xc,%esp
    42d0:	50                   	push   %eax
    42d1:	e8 7d fc ff ff       	call   3f53 <sbrk>
    42d6:	83 c4 10             	add    $0x10,%esp
    42d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    42dc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    42e0:	75 07                	jne    42e9 <morecore+0x38>
    return 0;
    42e2:	b8 00 00 00 00       	mov    $0x0,%eax
    42e7:	eb 26                	jmp    430f <morecore+0x5e>
  hp = (Header*)p;
    42e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    42ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    42ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
    42f2:	8b 55 08             	mov    0x8(%ebp),%edx
    42f5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    42f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    42fb:	83 c0 08             	add    $0x8,%eax
    42fe:	83 ec 0c             	sub    $0xc,%esp
    4301:	50                   	push   %eax
    4302:	e8 c8 fe ff ff       	call   41cf <free>
    4307:	83 c4 10             	add    $0x10,%esp
  return freep;
    430a:	a1 68 63 00 00       	mov    0x6368,%eax
}
    430f:	c9                   	leave  
    4310:	c3                   	ret    

00004311 <malloc>:

void*
malloc(uint nbytes)
{
    4311:	55                   	push   %ebp
    4312:	89 e5                	mov    %esp,%ebp
    4314:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4317:	8b 45 08             	mov    0x8(%ebp),%eax
    431a:	83 c0 07             	add    $0x7,%eax
    431d:	c1 e8 03             	shr    $0x3,%eax
    4320:	83 c0 01             	add    $0x1,%eax
    4323:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    4326:	a1 68 63 00 00       	mov    0x6368,%eax
    432b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    432e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4332:	75 23                	jne    4357 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    4334:	c7 45 f0 60 63 00 00 	movl   $0x6360,-0x10(%ebp)
    433b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    433e:	a3 68 63 00 00       	mov    %eax,0x6368
    4343:	a1 68 63 00 00       	mov    0x6368,%eax
    4348:	a3 60 63 00 00       	mov    %eax,0x6360
    base.s.size = 0;
    434d:	c7 05 64 63 00 00 00 	movl   $0x0,0x6364
    4354:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4357:	8b 45 f0             	mov    -0x10(%ebp),%eax
    435a:	8b 00                	mov    (%eax),%eax
    435c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    435f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4362:	8b 40 04             	mov    0x4(%eax),%eax
    4365:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    4368:	77 4d                	ja     43b7 <malloc+0xa6>
      if(p->s.size == nunits)
    436a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    436d:	8b 40 04             	mov    0x4(%eax),%eax
    4370:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    4373:	75 0c                	jne    4381 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    4375:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4378:	8b 10                	mov    (%eax),%edx
    437a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    437d:	89 10                	mov    %edx,(%eax)
    437f:	eb 26                	jmp    43a7 <malloc+0x96>
      else {
        p->s.size -= nunits;
    4381:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4384:	8b 40 04             	mov    0x4(%eax),%eax
    4387:	2b 45 ec             	sub    -0x14(%ebp),%eax
    438a:	89 c2                	mov    %eax,%edx
    438c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    438f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    4392:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4395:	8b 40 04             	mov    0x4(%eax),%eax
    4398:	c1 e0 03             	shl    $0x3,%eax
    439b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    439e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
    43a4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    43a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    43aa:	a3 68 63 00 00       	mov    %eax,0x6368
      return (void*)(p + 1);
    43af:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43b2:	83 c0 08             	add    $0x8,%eax
    43b5:	eb 3b                	jmp    43f2 <malloc+0xe1>
    }
    if(p == freep)
    43b7:	a1 68 63 00 00       	mov    0x6368,%eax
    43bc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    43bf:	75 1e                	jne    43df <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    43c1:	83 ec 0c             	sub    $0xc,%esp
    43c4:	ff 75 ec             	pushl  -0x14(%ebp)
    43c7:	e8 e5 fe ff ff       	call   42b1 <morecore>
    43cc:	83 c4 10             	add    $0x10,%esp
    43cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    43d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    43d6:	75 07                	jne    43df <malloc+0xce>
        return 0;
    43d8:	b8 00 00 00 00       	mov    $0x0,%eax
    43dd:	eb 13                	jmp    43f2 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    43df:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    43e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43e8:	8b 00                	mov    (%eax),%eax
    43ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    43ed:	e9 6d ff ff ff       	jmp    435f <malloc+0x4e>
  }
}
    43f2:	c9                   	leave  
    43f3:	c3                   	ret    
