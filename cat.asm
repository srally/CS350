
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 15                	jmp    1d <cat+0x1d>
    write(1, buf, n);
   8:	83 ec 04             	sub    $0x4,%esp
   b:	ff 75 f4             	pushl  -0xc(%ebp)
   e:	68 60 0b 00 00       	push   $0xb60
  13:	6a 01                	push   $0x1
  15:	e8 6c 03 00 00       	call   386 <write>
  1a:	83 c4 10             	add    $0x10,%esp
  while((n = read(fd, buf, sizeof(buf))) > 0)
  1d:	83 ec 04             	sub    $0x4,%esp
  20:	68 00 02 00 00       	push   $0x200
  25:	68 60 0b 00 00       	push   $0xb60
  2a:	ff 75 08             	pushl  0x8(%ebp)
  2d:	e8 4c 03 00 00       	call   37e <read>
  32:	83 c4 10             	add    $0x10,%esp
  35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  3c:	7f ca                	jg     8 <cat+0x8>
  if(n < 0){
  3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  42:	79 17                	jns    5b <cat+0x5b>
    printf(1, "cat: read error\n");
  44:	83 ec 08             	sub    $0x8,%esp
  47:	68 8f 08 00 00       	push   $0x88f
  4c:	6a 01                	push   $0x1
  4e:	e8 86 04 00 00       	call   4d9 <printf>
  53:	83 c4 10             	add    $0x10,%esp
    exit();
  56:	e8 0b 03 00 00       	call   366 <exit>
  }
}
  5b:	90                   	nop
  5c:	c9                   	leave  
  5d:	c3                   	ret    

0000005e <main>:

int
main(int argc, char *argv[])
{
  5e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  62:	83 e4 f0             	and    $0xfffffff0,%esp
  65:	ff 71 fc             	pushl  -0x4(%ecx)
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	53                   	push   %ebx
  6c:	51                   	push   %ecx
  6d:	83 ec 10             	sub    $0x10,%esp
  70:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
  72:	83 3b 01             	cmpl   $0x1,(%ebx)
  75:	7f 12                	jg     89 <main+0x2b>
    cat(0);
  77:	83 ec 0c             	sub    $0xc,%esp
  7a:	6a 00                	push   $0x0
  7c:	e8 7f ff ff ff       	call   0 <cat>
  81:	83 c4 10             	add    $0x10,%esp
    exit();
  84:	e8 dd 02 00 00       	call   366 <exit>
  }

  for(i = 1; i < argc; i++){
  89:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  90:	eb 71                	jmp    103 <main+0xa5>
    if((fd = open(argv[i], 0)) < 0){
  92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  95:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  9c:	8b 43 04             	mov    0x4(%ebx),%eax
  9f:	01 d0                	add    %edx,%eax
  a1:	8b 00                	mov    (%eax),%eax
  a3:	83 ec 08             	sub    $0x8,%esp
  a6:	6a 00                	push   $0x0
  a8:	50                   	push   %eax
  a9:	e8 f8 02 00 00       	call   3a6 <open>
  ae:	83 c4 10             	add    $0x10,%esp
  b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  b8:	79 29                	jns    e3 <main+0x85>
      printf(1, "cat: cannot open %s\n", argv[i]);
  ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  c4:	8b 43 04             	mov    0x4(%ebx),%eax
  c7:	01 d0                	add    %edx,%eax
  c9:	8b 00                	mov    (%eax),%eax
  cb:	83 ec 04             	sub    $0x4,%esp
  ce:	50                   	push   %eax
  cf:	68 a0 08 00 00       	push   $0x8a0
  d4:	6a 01                	push   $0x1
  d6:	e8 fe 03 00 00       	call   4d9 <printf>
  db:	83 c4 10             	add    $0x10,%esp
      exit();
  de:	e8 83 02 00 00       	call   366 <exit>
    }
    cat(fd);
  e3:	83 ec 0c             	sub    $0xc,%esp
  e6:	ff 75 f0             	pushl  -0x10(%ebp)
  e9:	e8 12 ff ff ff       	call   0 <cat>
  ee:	83 c4 10             	add    $0x10,%esp
    close(fd);
  f1:	83 ec 0c             	sub    $0xc,%esp
  f4:	ff 75 f0             	pushl  -0x10(%ebp)
  f7:	e8 92 02 00 00       	call   38e <close>
  fc:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++){
  ff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 103:	8b 45 f4             	mov    -0xc(%ebp),%eax
 106:	3b 03                	cmp    (%ebx),%eax
 108:	7c 88                	jl     92 <main+0x34>
  }
  exit();
 10a:	e8 57 02 00 00       	call   366 <exit>

0000010f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	57                   	push   %edi
 113:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 114:	8b 4d 08             	mov    0x8(%ebp),%ecx
 117:	8b 55 10             	mov    0x10(%ebp),%edx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	89 cb                	mov    %ecx,%ebx
 11f:	89 df                	mov    %ebx,%edi
 121:	89 d1                	mov    %edx,%ecx
 123:	fc                   	cld    
 124:	f3 aa                	rep stos %al,%es:(%edi)
 126:	89 ca                	mov    %ecx,%edx
 128:	89 fb                	mov    %edi,%ebx
 12a:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 130:	90                   	nop
 131:	5b                   	pop    %ebx
 132:	5f                   	pop    %edi
 133:	5d                   	pop    %ebp
 134:	c3                   	ret    

00000135 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 141:	90                   	nop
 142:	8b 55 0c             	mov    0xc(%ebp),%edx
 145:	8d 42 01             	lea    0x1(%edx),%eax
 148:	89 45 0c             	mov    %eax,0xc(%ebp)
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	8d 48 01             	lea    0x1(%eax),%ecx
 151:	89 4d 08             	mov    %ecx,0x8(%ebp)
 154:	0f b6 12             	movzbl (%edx),%edx
 157:	88 10                	mov    %dl,(%eax)
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	84 c0                	test   %al,%al
 15e:	75 e2                	jne    142 <strcpy+0xd>
    ;
  return os;
 160:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 163:	c9                   	leave  
 164:	c3                   	ret    

00000165 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 168:	eb 08                	jmp    172 <strcmp+0xd>
    p++, q++;
 16a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	0f b6 00             	movzbl (%eax),%eax
 178:	84 c0                	test   %al,%al
 17a:	74 10                	je     18c <strcmp+0x27>
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	0f b6 10             	movzbl (%eax),%edx
 182:	8b 45 0c             	mov    0xc(%ebp),%eax
 185:	0f b6 00             	movzbl (%eax),%eax
 188:	38 c2                	cmp    %al,%dl
 18a:	74 de                	je     16a <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	0f b6 00             	movzbl (%eax),%eax
 192:	0f b6 d0             	movzbl %al,%edx
 195:	8b 45 0c             	mov    0xc(%ebp),%eax
 198:	0f b6 00             	movzbl (%eax),%eax
 19b:	0f b6 c0             	movzbl %al,%eax
 19e:	29 c2                	sub    %eax,%edx
 1a0:	89 d0                	mov    %edx,%eax
}
 1a2:	5d                   	pop    %ebp
 1a3:	c3                   	ret    

000001a4 <strlen>:

uint
strlen(char *s)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b1:	eb 04                	jmp    1b7 <strlen+0x13>
 1b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	01 d0                	add    %edx,%eax
 1bf:	0f b6 00             	movzbl (%eax),%eax
 1c2:	84 c0                	test   %al,%al
 1c4:	75 ed                	jne    1b3 <strlen+0xf>
    ;
  return n;
 1c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c9:	c9                   	leave  
 1ca:	c3                   	ret    

000001cb <memset>:

void*
memset(void *dst, int c, uint n)
{
 1cb:	55                   	push   %ebp
 1cc:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1ce:	8b 45 10             	mov    0x10(%ebp),%eax
 1d1:	50                   	push   %eax
 1d2:	ff 75 0c             	pushl  0xc(%ebp)
 1d5:	ff 75 08             	pushl  0x8(%ebp)
 1d8:	e8 32 ff ff ff       	call   10f <stosb>
 1dd:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e3:	c9                   	leave  
 1e4:	c3                   	ret    

000001e5 <strchr>:

char*
strchr(const char *s, char c)
{
 1e5:	55                   	push   %ebp
 1e6:	89 e5                	mov    %esp,%ebp
 1e8:	83 ec 04             	sub    $0x4,%esp
 1eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ee:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1f1:	eb 14                	jmp    207 <strchr+0x22>
    if(*s == c)
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	0f b6 00             	movzbl (%eax),%eax
 1f9:	38 45 fc             	cmp    %al,-0x4(%ebp)
 1fc:	75 05                	jne    203 <strchr+0x1e>
      return (char*)s;
 1fe:	8b 45 08             	mov    0x8(%ebp),%eax
 201:	eb 13                	jmp    216 <strchr+0x31>
  for(; *s; s++)
 203:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	0f b6 00             	movzbl (%eax),%eax
 20d:	84 c0                	test   %al,%al
 20f:	75 e2                	jne    1f3 <strchr+0xe>
  return 0;
 211:	b8 00 00 00 00       	mov    $0x0,%eax
}
 216:	c9                   	leave  
 217:	c3                   	ret    

00000218 <gets>:

char*
gets(char *buf, int max)
{
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
 21b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 225:	eb 42                	jmp    269 <gets+0x51>
    cc = read(0, &c, 1);
 227:	83 ec 04             	sub    $0x4,%esp
 22a:	6a 01                	push   $0x1
 22c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 22f:	50                   	push   %eax
 230:	6a 00                	push   $0x0
 232:	e8 47 01 00 00       	call   37e <read>
 237:	83 c4 10             	add    $0x10,%esp
 23a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 23d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 241:	7e 33                	jle    276 <gets+0x5e>
      break;
    buf[i++] = c;
 243:	8b 45 f4             	mov    -0xc(%ebp),%eax
 246:	8d 50 01             	lea    0x1(%eax),%edx
 249:	89 55 f4             	mov    %edx,-0xc(%ebp)
 24c:	89 c2                	mov    %eax,%edx
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	01 c2                	add    %eax,%edx
 253:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 257:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 259:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 25d:	3c 0a                	cmp    $0xa,%al
 25f:	74 16                	je     277 <gets+0x5f>
 261:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 265:	3c 0d                	cmp    $0xd,%al
 267:	74 0e                	je     277 <gets+0x5f>
  for(i=0; i+1 < max; ){
 269:	8b 45 f4             	mov    -0xc(%ebp),%eax
 26c:	83 c0 01             	add    $0x1,%eax
 26f:	39 45 0c             	cmp    %eax,0xc(%ebp)
 272:	7f b3                	jg     227 <gets+0xf>
 274:	eb 01                	jmp    277 <gets+0x5f>
      break;
 276:	90                   	nop
      break;
  }
  buf[i] = '\0';
 277:	8b 55 f4             	mov    -0xc(%ebp),%edx
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
 27d:	01 d0                	add    %edx,%eax
 27f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 282:	8b 45 08             	mov    0x8(%ebp),%eax
}
 285:	c9                   	leave  
 286:	c3                   	ret    

00000287 <stat>:

int
stat(char *n, struct stat *st)
{
 287:	55                   	push   %ebp
 288:	89 e5                	mov    %esp,%ebp
 28a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 28d:	83 ec 08             	sub    $0x8,%esp
 290:	6a 00                	push   $0x0
 292:	ff 75 08             	pushl  0x8(%ebp)
 295:	e8 0c 01 00 00       	call   3a6 <open>
 29a:	83 c4 10             	add    $0x10,%esp
 29d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2a4:	79 07                	jns    2ad <stat+0x26>
    return -1;
 2a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ab:	eb 25                	jmp    2d2 <stat+0x4b>
  r = fstat(fd, st);
 2ad:	83 ec 08             	sub    $0x8,%esp
 2b0:	ff 75 0c             	pushl  0xc(%ebp)
 2b3:	ff 75 f4             	pushl  -0xc(%ebp)
 2b6:	e8 03 01 00 00       	call   3be <fstat>
 2bb:	83 c4 10             	add    $0x10,%esp
 2be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2c1:	83 ec 0c             	sub    $0xc,%esp
 2c4:	ff 75 f4             	pushl  -0xc(%ebp)
 2c7:	e8 c2 00 00 00       	call   38e <close>
 2cc:	83 c4 10             	add    $0x10,%esp
  return r;
 2cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2d2:	c9                   	leave  
 2d3:	c3                   	ret    

000002d4 <atoi>:

int
atoi(const char *s)
{
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2e1:	eb 25                	jmp    308 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e6:	89 d0                	mov    %edx,%eax
 2e8:	c1 e0 02             	shl    $0x2,%eax
 2eb:	01 d0                	add    %edx,%eax
 2ed:	01 c0                	add    %eax,%eax
 2ef:	89 c1                	mov    %eax,%ecx
 2f1:	8b 45 08             	mov    0x8(%ebp),%eax
 2f4:	8d 50 01             	lea    0x1(%eax),%edx
 2f7:	89 55 08             	mov    %edx,0x8(%ebp)
 2fa:	0f b6 00             	movzbl (%eax),%eax
 2fd:	0f be c0             	movsbl %al,%eax
 300:	01 c8                	add    %ecx,%eax
 302:	83 e8 30             	sub    $0x30,%eax
 305:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	0f b6 00             	movzbl (%eax),%eax
 30e:	3c 2f                	cmp    $0x2f,%al
 310:	7e 0a                	jle    31c <atoi+0x48>
 312:	8b 45 08             	mov    0x8(%ebp),%eax
 315:	0f b6 00             	movzbl (%eax),%eax
 318:	3c 39                	cmp    $0x39,%al
 31a:	7e c7                	jle    2e3 <atoi+0xf>
  return n;
 31c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 31f:	c9                   	leave  
 320:	c3                   	ret    

00000321 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 321:	55                   	push   %ebp
 322:	89 e5                	mov    %esp,%ebp
 324:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 32d:	8b 45 0c             	mov    0xc(%ebp),%eax
 330:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 333:	eb 17                	jmp    34c <memmove+0x2b>
    *dst++ = *src++;
 335:	8b 55 f8             	mov    -0x8(%ebp),%edx
 338:	8d 42 01             	lea    0x1(%edx),%eax
 33b:	89 45 f8             	mov    %eax,-0x8(%ebp)
 33e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 341:	8d 48 01             	lea    0x1(%eax),%ecx
 344:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 347:	0f b6 12             	movzbl (%edx),%edx
 34a:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 34c:	8b 45 10             	mov    0x10(%ebp),%eax
 34f:	8d 50 ff             	lea    -0x1(%eax),%edx
 352:	89 55 10             	mov    %edx,0x10(%ebp)
 355:	85 c0                	test   %eax,%eax
 357:	7f dc                	jg     335 <memmove+0x14>
  return vdst;
 359:	8b 45 08             	mov    0x8(%ebp),%eax
}
 35c:	c9                   	leave  
 35d:	c3                   	ret    

0000035e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 35e:	b8 01 00 00 00       	mov    $0x1,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <exit>:
SYSCALL(exit)
 366:	b8 02 00 00 00       	mov    $0x2,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <wait>:
SYSCALL(wait)
 36e:	b8 03 00 00 00       	mov    $0x3,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <pipe>:
SYSCALL(pipe)
 376:	b8 04 00 00 00       	mov    $0x4,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <read>:
SYSCALL(read)
 37e:	b8 05 00 00 00       	mov    $0x5,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <write>:
SYSCALL(write)
 386:	b8 10 00 00 00       	mov    $0x10,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <close>:
SYSCALL(close)
 38e:	b8 15 00 00 00       	mov    $0x15,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <kill>:
SYSCALL(kill)
 396:	b8 06 00 00 00       	mov    $0x6,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <exec>:
SYSCALL(exec)
 39e:	b8 07 00 00 00       	mov    $0x7,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <open>:
SYSCALL(open)
 3a6:	b8 0f 00 00 00       	mov    $0xf,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <mknod>:
SYSCALL(mknod)
 3ae:	b8 11 00 00 00       	mov    $0x11,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <unlink>:
SYSCALL(unlink)
 3b6:	b8 12 00 00 00       	mov    $0x12,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <fstat>:
SYSCALL(fstat)
 3be:	b8 08 00 00 00       	mov    $0x8,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <link>:
SYSCALL(link)
 3c6:	b8 13 00 00 00       	mov    $0x13,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <mkdir>:
SYSCALL(mkdir)
 3ce:	b8 14 00 00 00       	mov    $0x14,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <chdir>:
SYSCALL(chdir)
 3d6:	b8 09 00 00 00       	mov    $0x9,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <dup>:
SYSCALL(dup)
 3de:	b8 0a 00 00 00       	mov    $0xa,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <getpid>:
SYSCALL(getpid)
 3e6:	b8 0b 00 00 00       	mov    $0xb,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <sbrk>:
SYSCALL(sbrk)
 3ee:	b8 0c 00 00 00       	mov    $0xc,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <sleep>:
SYSCALL(sleep)
 3f6:	b8 0d 00 00 00       	mov    $0xd,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <uptime>:
SYSCALL(uptime)
 3fe:	b8 0e 00 00 00       	mov    $0xe,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 406:	55                   	push   %ebp
 407:	89 e5                	mov    %esp,%ebp
 409:	83 ec 18             	sub    $0x18,%esp
 40c:	8b 45 0c             	mov    0xc(%ebp),%eax
 40f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 412:	83 ec 04             	sub    $0x4,%esp
 415:	6a 01                	push   $0x1
 417:	8d 45 f4             	lea    -0xc(%ebp),%eax
 41a:	50                   	push   %eax
 41b:	ff 75 08             	pushl  0x8(%ebp)
 41e:	e8 63 ff ff ff       	call   386 <write>
 423:	83 c4 10             	add    $0x10,%esp
}
 426:	90                   	nop
 427:	c9                   	leave  
 428:	c3                   	ret    

00000429 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 429:	55                   	push   %ebp
 42a:	89 e5                	mov    %esp,%ebp
 42c:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 42f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 436:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 43a:	74 17                	je     453 <printint+0x2a>
 43c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 440:	79 11                	jns    453 <printint+0x2a>
    neg = 1;
 442:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 449:	8b 45 0c             	mov    0xc(%ebp),%eax
 44c:	f7 d8                	neg    %eax
 44e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 451:	eb 06                	jmp    459 <printint+0x30>
  } else {
    x = xx;
 453:	8b 45 0c             	mov    0xc(%ebp),%eax
 456:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 459:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 460:	8b 4d 10             	mov    0x10(%ebp),%ecx
 463:	8b 45 ec             	mov    -0x14(%ebp),%eax
 466:	ba 00 00 00 00       	mov    $0x0,%edx
 46b:	f7 f1                	div    %ecx
 46d:	89 d1                	mov    %edx,%ecx
 46f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 472:	8d 50 01             	lea    0x1(%eax),%edx
 475:	89 55 f4             	mov    %edx,-0xc(%ebp)
 478:	0f b6 91 24 0b 00 00 	movzbl 0xb24(%ecx),%edx
 47f:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 483:	8b 4d 10             	mov    0x10(%ebp),%ecx
 486:	8b 45 ec             	mov    -0x14(%ebp),%eax
 489:	ba 00 00 00 00       	mov    $0x0,%edx
 48e:	f7 f1                	div    %ecx
 490:	89 45 ec             	mov    %eax,-0x14(%ebp)
 493:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 497:	75 c7                	jne    460 <printint+0x37>
  if(neg)
 499:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 49d:	74 2d                	je     4cc <printint+0xa3>
    buf[i++] = '-';
 49f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a2:	8d 50 01             	lea    0x1(%eax),%edx
 4a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4a8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4ad:	eb 1d                	jmp    4cc <printint+0xa3>
    putc(fd, buf[i]);
 4af:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b5:	01 d0                	add    %edx,%eax
 4b7:	0f b6 00             	movzbl (%eax),%eax
 4ba:	0f be c0             	movsbl %al,%eax
 4bd:	83 ec 08             	sub    $0x8,%esp
 4c0:	50                   	push   %eax
 4c1:	ff 75 08             	pushl  0x8(%ebp)
 4c4:	e8 3d ff ff ff       	call   406 <putc>
 4c9:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4cc:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4d4:	79 d9                	jns    4af <printint+0x86>
}
 4d6:	90                   	nop
 4d7:	c9                   	leave  
 4d8:	c3                   	ret    

000004d9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4d9:	55                   	push   %ebp
 4da:	89 e5                	mov    %esp,%ebp
 4dc:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4e6:	8d 45 0c             	lea    0xc(%ebp),%eax
 4e9:	83 c0 04             	add    $0x4,%eax
 4ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4ef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4f6:	e9 59 01 00 00       	jmp    654 <printf+0x17b>
    c = fmt[i] & 0xff;
 4fb:	8b 55 0c             	mov    0xc(%ebp),%edx
 4fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 501:	01 d0                	add    %edx,%eax
 503:	0f b6 00             	movzbl (%eax),%eax
 506:	0f be c0             	movsbl %al,%eax
 509:	25 ff 00 00 00       	and    $0xff,%eax
 50e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 511:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 515:	75 2c                	jne    543 <printf+0x6a>
      if(c == '%'){
 517:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 51b:	75 0c                	jne    529 <printf+0x50>
        state = '%';
 51d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 524:	e9 27 01 00 00       	jmp    650 <printf+0x177>
      } else {
        putc(fd, c);
 529:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 52c:	0f be c0             	movsbl %al,%eax
 52f:	83 ec 08             	sub    $0x8,%esp
 532:	50                   	push   %eax
 533:	ff 75 08             	pushl  0x8(%ebp)
 536:	e8 cb fe ff ff       	call   406 <putc>
 53b:	83 c4 10             	add    $0x10,%esp
 53e:	e9 0d 01 00 00       	jmp    650 <printf+0x177>
      }
    } else if(state == '%'){
 543:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 547:	0f 85 03 01 00 00    	jne    650 <printf+0x177>
      if(c == 'd'){
 54d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 551:	75 1e                	jne    571 <printf+0x98>
        printint(fd, *ap, 10, 1);
 553:	8b 45 e8             	mov    -0x18(%ebp),%eax
 556:	8b 00                	mov    (%eax),%eax
 558:	6a 01                	push   $0x1
 55a:	6a 0a                	push   $0xa
 55c:	50                   	push   %eax
 55d:	ff 75 08             	pushl  0x8(%ebp)
 560:	e8 c4 fe ff ff       	call   429 <printint>
 565:	83 c4 10             	add    $0x10,%esp
        ap++;
 568:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 56c:	e9 d8 00 00 00       	jmp    649 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 571:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 575:	74 06                	je     57d <printf+0xa4>
 577:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 57b:	75 1e                	jne    59b <printf+0xc2>
        printint(fd, *ap, 16, 0);
 57d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 580:	8b 00                	mov    (%eax),%eax
 582:	6a 00                	push   $0x0
 584:	6a 10                	push   $0x10
 586:	50                   	push   %eax
 587:	ff 75 08             	pushl  0x8(%ebp)
 58a:	e8 9a fe ff ff       	call   429 <printint>
 58f:	83 c4 10             	add    $0x10,%esp
        ap++;
 592:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 596:	e9 ae 00 00 00       	jmp    649 <printf+0x170>
      } else if(c == 's'){
 59b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 59f:	75 43                	jne    5e4 <printf+0x10b>
        s = (char*)*ap;
 5a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a4:	8b 00                	mov    (%eax),%eax
 5a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5b1:	75 25                	jne    5d8 <printf+0xff>
          s = "(null)";
 5b3:	c7 45 f4 b5 08 00 00 	movl   $0x8b5,-0xc(%ebp)
        while(*s != 0){
 5ba:	eb 1c                	jmp    5d8 <printf+0xff>
          putc(fd, *s);
 5bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5bf:	0f b6 00             	movzbl (%eax),%eax
 5c2:	0f be c0             	movsbl %al,%eax
 5c5:	83 ec 08             	sub    $0x8,%esp
 5c8:	50                   	push   %eax
 5c9:	ff 75 08             	pushl  0x8(%ebp)
 5cc:	e8 35 fe ff ff       	call   406 <putc>
 5d1:	83 c4 10             	add    $0x10,%esp
          s++;
 5d4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5db:	0f b6 00             	movzbl (%eax),%eax
 5de:	84 c0                	test   %al,%al
 5e0:	75 da                	jne    5bc <printf+0xe3>
 5e2:	eb 65                	jmp    649 <printf+0x170>
        }
      } else if(c == 'c'){
 5e4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5e8:	75 1d                	jne    607 <printf+0x12e>
        putc(fd, *ap);
 5ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ed:	8b 00                	mov    (%eax),%eax
 5ef:	0f be c0             	movsbl %al,%eax
 5f2:	83 ec 08             	sub    $0x8,%esp
 5f5:	50                   	push   %eax
 5f6:	ff 75 08             	pushl  0x8(%ebp)
 5f9:	e8 08 fe ff ff       	call   406 <putc>
 5fe:	83 c4 10             	add    $0x10,%esp
        ap++;
 601:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 605:	eb 42                	jmp    649 <printf+0x170>
      } else if(c == '%'){
 607:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 60b:	75 17                	jne    624 <printf+0x14b>
        putc(fd, c);
 60d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 610:	0f be c0             	movsbl %al,%eax
 613:	83 ec 08             	sub    $0x8,%esp
 616:	50                   	push   %eax
 617:	ff 75 08             	pushl  0x8(%ebp)
 61a:	e8 e7 fd ff ff       	call   406 <putc>
 61f:	83 c4 10             	add    $0x10,%esp
 622:	eb 25                	jmp    649 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 624:	83 ec 08             	sub    $0x8,%esp
 627:	6a 25                	push   $0x25
 629:	ff 75 08             	pushl  0x8(%ebp)
 62c:	e8 d5 fd ff ff       	call   406 <putc>
 631:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 634:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 637:	0f be c0             	movsbl %al,%eax
 63a:	83 ec 08             	sub    $0x8,%esp
 63d:	50                   	push   %eax
 63e:	ff 75 08             	pushl  0x8(%ebp)
 641:	e8 c0 fd ff ff       	call   406 <putc>
 646:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 649:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 650:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 654:	8b 55 0c             	mov    0xc(%ebp),%edx
 657:	8b 45 f0             	mov    -0x10(%ebp),%eax
 65a:	01 d0                	add    %edx,%eax
 65c:	0f b6 00             	movzbl (%eax),%eax
 65f:	84 c0                	test   %al,%al
 661:	0f 85 94 fe ff ff    	jne    4fb <printf+0x22>
    }
  }
}
 667:	90                   	nop
 668:	c9                   	leave  
 669:	c3                   	ret    

0000066a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 66a:	55                   	push   %ebp
 66b:	89 e5                	mov    %esp,%ebp
 66d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 670:	8b 45 08             	mov    0x8(%ebp),%eax
 673:	83 e8 08             	sub    $0x8,%eax
 676:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 679:	a1 48 0b 00 00       	mov    0xb48,%eax
 67e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 681:	eb 24                	jmp    6a7 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 683:	8b 45 fc             	mov    -0x4(%ebp),%eax
 686:	8b 00                	mov    (%eax),%eax
 688:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 68b:	72 12                	jb     69f <free+0x35>
 68d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 690:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 693:	77 24                	ja     6b9 <free+0x4f>
 695:	8b 45 fc             	mov    -0x4(%ebp),%eax
 698:	8b 00                	mov    (%eax),%eax
 69a:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 69d:	72 1a                	jb     6b9 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a2:	8b 00                	mov    (%eax),%eax
 6a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6aa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ad:	76 d4                	jbe    683 <free+0x19>
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	8b 00                	mov    (%eax),%eax
 6b4:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6b7:	73 ca                	jae    683 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bc:	8b 40 04             	mov    0x4(%eax),%eax
 6bf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c9:	01 c2                	add    %eax,%edx
 6cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ce:	8b 00                	mov    (%eax),%eax
 6d0:	39 c2                	cmp    %eax,%edx
 6d2:	75 24                	jne    6f8 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d7:	8b 50 04             	mov    0x4(%eax),%edx
 6da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dd:	8b 00                	mov    (%eax),%eax
 6df:	8b 40 04             	mov    0x4(%eax),%eax
 6e2:	01 c2                	add    %eax,%edx
 6e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e7:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ed:	8b 00                	mov    (%eax),%eax
 6ef:	8b 10                	mov    (%eax),%edx
 6f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f4:	89 10                	mov    %edx,(%eax)
 6f6:	eb 0a                	jmp    702 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fb:	8b 10                	mov    (%eax),%edx
 6fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 700:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 702:	8b 45 fc             	mov    -0x4(%ebp),%eax
 705:	8b 40 04             	mov    0x4(%eax),%eax
 708:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 70f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 712:	01 d0                	add    %edx,%eax
 714:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 717:	75 20                	jne    739 <free+0xcf>
    p->s.size += bp->s.size;
 719:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71c:	8b 50 04             	mov    0x4(%eax),%edx
 71f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 722:	8b 40 04             	mov    0x4(%eax),%eax
 725:	01 c2                	add    %eax,%edx
 727:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 72d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 730:	8b 10                	mov    (%eax),%edx
 732:	8b 45 fc             	mov    -0x4(%ebp),%eax
 735:	89 10                	mov    %edx,(%eax)
 737:	eb 08                	jmp    741 <free+0xd7>
  } else
    p->s.ptr = bp;
 739:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 73f:	89 10                	mov    %edx,(%eax)
  freep = p;
 741:	8b 45 fc             	mov    -0x4(%ebp),%eax
 744:	a3 48 0b 00 00       	mov    %eax,0xb48
}
 749:	90                   	nop
 74a:	c9                   	leave  
 74b:	c3                   	ret    

0000074c <morecore>:

static Header*
morecore(uint nu)
{
 74c:	55                   	push   %ebp
 74d:	89 e5                	mov    %esp,%ebp
 74f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 752:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 759:	77 07                	ja     762 <morecore+0x16>
    nu = 4096;
 75b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 762:	8b 45 08             	mov    0x8(%ebp),%eax
 765:	c1 e0 03             	shl    $0x3,%eax
 768:	83 ec 0c             	sub    $0xc,%esp
 76b:	50                   	push   %eax
 76c:	e8 7d fc ff ff       	call   3ee <sbrk>
 771:	83 c4 10             	add    $0x10,%esp
 774:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 777:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 77b:	75 07                	jne    784 <morecore+0x38>
    return 0;
 77d:	b8 00 00 00 00       	mov    $0x0,%eax
 782:	eb 26                	jmp    7aa <morecore+0x5e>
  hp = (Header*)p;
 784:	8b 45 f4             	mov    -0xc(%ebp),%eax
 787:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 78a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78d:	8b 55 08             	mov    0x8(%ebp),%edx
 790:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 793:	8b 45 f0             	mov    -0x10(%ebp),%eax
 796:	83 c0 08             	add    $0x8,%eax
 799:	83 ec 0c             	sub    $0xc,%esp
 79c:	50                   	push   %eax
 79d:	e8 c8 fe ff ff       	call   66a <free>
 7a2:	83 c4 10             	add    $0x10,%esp
  return freep;
 7a5:	a1 48 0b 00 00       	mov    0xb48,%eax
}
 7aa:	c9                   	leave  
 7ab:	c3                   	ret    

000007ac <malloc>:

void*
malloc(uint nbytes)
{
 7ac:	55                   	push   %ebp
 7ad:	89 e5                	mov    %esp,%ebp
 7af:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b2:	8b 45 08             	mov    0x8(%ebp),%eax
 7b5:	83 c0 07             	add    $0x7,%eax
 7b8:	c1 e8 03             	shr    $0x3,%eax
 7bb:	83 c0 01             	add    $0x1,%eax
 7be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7c1:	a1 48 0b 00 00       	mov    0xb48,%eax
 7c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7cd:	75 23                	jne    7f2 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7cf:	c7 45 f0 40 0b 00 00 	movl   $0xb40,-0x10(%ebp)
 7d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d9:	a3 48 0b 00 00       	mov    %eax,0xb48
 7de:	a1 48 0b 00 00       	mov    0xb48,%eax
 7e3:	a3 40 0b 00 00       	mov    %eax,0xb40
    base.s.size = 0;
 7e8:	c7 05 44 0b 00 00 00 	movl   $0x0,0xb44
 7ef:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f5:	8b 00                	mov    (%eax),%eax
 7f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fd:	8b 40 04             	mov    0x4(%eax),%eax
 800:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 803:	77 4d                	ja     852 <malloc+0xa6>
      if(p->s.size == nunits)
 805:	8b 45 f4             	mov    -0xc(%ebp),%eax
 808:	8b 40 04             	mov    0x4(%eax),%eax
 80b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 80e:	75 0c                	jne    81c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 810:	8b 45 f4             	mov    -0xc(%ebp),%eax
 813:	8b 10                	mov    (%eax),%edx
 815:	8b 45 f0             	mov    -0x10(%ebp),%eax
 818:	89 10                	mov    %edx,(%eax)
 81a:	eb 26                	jmp    842 <malloc+0x96>
      else {
        p->s.size -= nunits;
 81c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81f:	8b 40 04             	mov    0x4(%eax),%eax
 822:	2b 45 ec             	sub    -0x14(%ebp),%eax
 825:	89 c2                	mov    %eax,%edx
 827:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 82d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 830:	8b 40 04             	mov    0x4(%eax),%eax
 833:	c1 e0 03             	shl    $0x3,%eax
 836:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 839:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 83f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 842:	8b 45 f0             	mov    -0x10(%ebp),%eax
 845:	a3 48 0b 00 00       	mov    %eax,0xb48
      return (void*)(p + 1);
 84a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84d:	83 c0 08             	add    $0x8,%eax
 850:	eb 3b                	jmp    88d <malloc+0xe1>
    }
    if(p == freep)
 852:	a1 48 0b 00 00       	mov    0xb48,%eax
 857:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 85a:	75 1e                	jne    87a <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 85c:	83 ec 0c             	sub    $0xc,%esp
 85f:	ff 75 ec             	pushl  -0x14(%ebp)
 862:	e8 e5 fe ff ff       	call   74c <morecore>
 867:	83 c4 10             	add    $0x10,%esp
 86a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 86d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 871:	75 07                	jne    87a <malloc+0xce>
        return 0;
 873:	b8 00 00 00 00       	mov    $0x0,%eax
 878:	eb 13                	jmp    88d <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 880:	8b 45 f4             	mov    -0xc(%ebp),%eax
 883:	8b 00                	mov    (%eax),%eax
 885:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 888:	e9 6d ff ff ff       	jmp    7fa <malloc+0x4e>
  }
}
 88d:	c9                   	leave  
 88e:	c3                   	ret    
