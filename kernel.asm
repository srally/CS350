
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 c6 10 80       	mov    $0x8010c650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 98 38 10 80       	mov    $0x80103898,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 70 85 10 80       	push   $0x80108570
80100042:	68 60 c6 10 80       	push   $0x8010c660
80100047:	e8 d6 4f 00 00       	call   80105022 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 70 05 11 80 64 	movl   $0x80110564,0x80110570
80100056:	05 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 74 05 11 80 64 	movl   $0x80110564,0x80110574
80100060:	05 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 94 c6 10 80 	movl   $0x8010c694,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 74 05 11 80    	mov    0x80110574,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 64 05 11 80 	movl   $0x80110564,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 74 05 11 80       	mov    0x80110574,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 74 05 11 80       	mov    %eax,0x80110574
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 64 05 11 80       	mov    $0x80110564,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
  }
}
801000b0:	90                   	nop
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    

801000b3 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b3:	55                   	push   %ebp
801000b4:	89 e5                	mov    %esp,%ebp
801000b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b9:	83 ec 0c             	sub    $0xc,%esp
801000bc:	68 60 c6 10 80       	push   $0x8010c660
801000c1:	e8 7e 4f 00 00       	call   80105044 <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 74 05 11 80       	mov    0x80110574,%eax
801000ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d1:	eb 67                	jmp    8010013a <bget+0x87>
    if(b->dev == dev && b->blockno == blockno){
801000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d6:	8b 40 04             	mov    0x4(%eax),%eax
801000d9:	39 45 08             	cmp    %eax,0x8(%ebp)
801000dc:	75 53                	jne    80100131 <bget+0x7e>
801000de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e1:	8b 40 08             	mov    0x8(%eax),%eax
801000e4:	39 45 0c             	cmp    %eax,0xc(%ebp)
801000e7:	75 48                	jne    80100131 <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ec:	8b 00                	mov    (%eax),%eax
801000ee:	83 e0 01             	and    $0x1,%eax
801000f1:	85 c0                	test   %eax,%eax
801000f3:	75 27                	jne    8010011c <bget+0x69>
        b->flags |= B_BUSY;
801000f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f8:	8b 00                	mov    (%eax),%eax
801000fa:	83 c8 01             	or     $0x1,%eax
801000fd:	89 c2                	mov    %eax,%edx
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100104:	83 ec 0c             	sub    $0xc,%esp
80100107:	68 60 c6 10 80       	push   $0x8010c660
8010010c:	e8 9a 4f 00 00       	call   801050ab <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 60 c6 10 80       	push   $0x8010c660
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 1f 4c 00 00       	call   80104d4b <sleep>
8010012c:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012f:	eb 98                	jmp    801000c9 <bget+0x16>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100134:	8b 40 10             	mov    0x10(%eax),%eax
80100137:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010013a:	81 7d f4 64 05 11 80 	cmpl   $0x80110564,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 70 05 11 80       	mov    0x80110570,%eax
80100148:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014b:	eb 51                	jmp    8010019e <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100150:	8b 00                	mov    (%eax),%eax
80100152:	83 e0 01             	and    $0x1,%eax
80100155:	85 c0                	test   %eax,%eax
80100157:	75 3c                	jne    80100195 <bget+0xe2>
80100159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015c:	8b 00                	mov    (%eax),%eax
8010015e:	83 e0 04             	and    $0x4,%eax
80100161:	85 c0                	test   %eax,%eax
80100163:	75 30                	jne    80100195 <bget+0xe2>
      b->dev = dev;
80100165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100168:	8b 55 08             	mov    0x8(%ebp),%edx
8010016b:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100171:	8b 55 0c             	mov    0xc(%ebp),%edx
80100174:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100180:	83 ec 0c             	sub    $0xc,%esp
80100183:	68 60 c6 10 80       	push   $0x8010c660
80100188:	e8 1e 4f 00 00       	call   801050ab <release>
8010018d:	83 c4 10             	add    $0x10,%esp
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1f                	jmp    801001b4 <bget+0x101>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 0c             	mov    0xc(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 64 05 11 80 	cmpl   $0x80110564,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 77 85 10 80       	push   $0x80108577
801001af:	e8 b3 03 00 00       	call   80100567 <panic>
}
801001b4:	c9                   	leave  
801001b5:	c3                   	ret    

801001b6 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b6:	55                   	push   %ebp
801001b7:	89 e5                	mov    %esp,%ebp
801001b9:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bc:	83 ec 08             	sub    $0x8,%esp
801001bf:	ff 75 0c             	pushl  0xc(%ebp)
801001c2:	ff 75 08             	pushl  0x8(%ebp)
801001c5:	e8 e9 fe ff ff       	call   801000b3 <bget>
801001ca:	83 c4 10             	add    $0x10,%esp
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0e                	jne    801001ea <bread+0x34>
    iderw(b);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	ff 75 f4             	pushl  -0xc(%ebp)
801001e2:	e8 2a 27 00 00       	call   80102911 <iderw>
801001e7:	83 c4 10             	add    $0x10,%esp
  }
  return b;
801001ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ed:	c9                   	leave  
801001ee:	c3                   	ret    

801001ef <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ef:	55                   	push   %ebp
801001f0:	89 e5                	mov    %esp,%ebp
801001f2:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f5:	8b 45 08             	mov    0x8(%ebp),%eax
801001f8:	8b 00                	mov    (%eax),%eax
801001fa:	83 e0 01             	and    $0x1,%eax
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 0d                	jne    8010020e <bwrite+0x1f>
    panic("bwrite");
80100201:	83 ec 0c             	sub    $0xc,%esp
80100204:	68 88 85 10 80       	push   $0x80108588
80100209:	e8 59 03 00 00       	call   80100567 <panic>
  b->flags |= B_DIRTY;
8010020e:	8b 45 08             	mov    0x8(%ebp),%eax
80100211:	8b 00                	mov    (%eax),%eax
80100213:	83 c8 04             	or     $0x4,%eax
80100216:	89 c2                	mov    %eax,%edx
80100218:	8b 45 08             	mov    0x8(%ebp),%eax
8010021b:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021d:	83 ec 0c             	sub    $0xc,%esp
80100220:	ff 75 08             	pushl  0x8(%ebp)
80100223:	e8 e9 26 00 00       	call   80102911 <iderw>
80100228:	83 c4 10             	add    $0x10,%esp
}
8010022b:	90                   	nop
8010022c:	c9                   	leave  
8010022d:	c3                   	ret    

8010022e <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022e:	55                   	push   %ebp
8010022f:	89 e5                	mov    %esp,%ebp
80100231:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100234:	8b 45 08             	mov    0x8(%ebp),%eax
80100237:	8b 00                	mov    (%eax),%eax
80100239:	83 e0 01             	and    $0x1,%eax
8010023c:	85 c0                	test   %eax,%eax
8010023e:	75 0d                	jne    8010024d <brelse+0x1f>
    panic("brelse");
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	68 8f 85 10 80       	push   $0x8010858f
80100248:	e8 1a 03 00 00       	call   80100567 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 60 c6 10 80       	push   $0x8010c660
80100255:	e8 ea 4d 00 00       	call   80105044 <acquire>
8010025a:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025d:	8b 45 08             	mov    0x8(%ebp),%eax
80100260:	8b 40 10             	mov    0x10(%eax),%eax
80100263:	8b 55 08             	mov    0x8(%ebp),%edx
80100266:	8b 52 0c             	mov    0xc(%edx),%edx
80100269:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
8010026c:	8b 45 08             	mov    0x8(%ebp),%eax
8010026f:	8b 40 0c             	mov    0xc(%eax),%eax
80100272:	8b 55 08             	mov    0x8(%ebp),%edx
80100275:	8b 52 10             	mov    0x10(%edx),%edx
80100278:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010027b:	8b 15 74 05 11 80    	mov    0x80110574,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c 64 05 11 80 	movl   $0x80110564,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 74 05 11 80       	mov    0x80110574,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 74 05 11 80       	mov    %eax,0x80110574

  b->flags &= ~B_BUSY;
801002a4:	8b 45 08             	mov    0x8(%ebp),%eax
801002a7:	8b 00                	mov    (%eax),%eax
801002a9:	83 e0 fe             	and    $0xfffffffe,%eax
801002ac:	89 c2                	mov    %eax,%edx
801002ae:	8b 45 08             	mov    0x8(%ebp),%eax
801002b1:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b3:	83 ec 0c             	sub    $0xc,%esp
801002b6:	ff 75 08             	pushl  0x8(%ebp)
801002b9:	e8 78 4b 00 00       	call   80104e36 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 60 c6 10 80       	push   $0x8010c660
801002c9:	e8 dd 4d 00 00       	call   801050ab <release>
801002ce:	83 c4 10             	add    $0x10,%esp
}
801002d1:	90                   	nop
801002d2:	c9                   	leave  
801002d3:	c3                   	ret    

801002d4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d4:	55                   	push   %ebp
801002d5:	89 e5                	mov    %esp,%ebp
801002d7:	83 ec 14             	sub    $0x14,%esp
801002da:	8b 45 08             	mov    0x8(%ebp),%eax
801002dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e5:	89 c2                	mov    %eax,%edx
801002e7:	ec                   	in     (%dx),%al
801002e8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002ef:	c9                   	leave  
801002f0:	c3                   	ret    

801002f1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	83 ec 08             	sub    $0x8,%esp
801002f7:	8b 45 08             	mov    0x8(%ebp),%eax
801002fa:	8b 55 0c             	mov    0xc(%ebp),%edx
801002fd:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80100301:	89 d0                	mov    %edx,%eax
80100303:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100306:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010030a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010030e:	ee                   	out    %al,(%dx)
}
8010030f:	90                   	nop
80100310:	c9                   	leave  
80100311:	c3                   	ret    

80100312 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100312:	55                   	push   %ebp
80100313:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100315:	fa                   	cli    
}
80100316:	90                   	nop
80100317:	5d                   	pop    %ebp
80100318:	c3                   	ret    

80100319 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100319:	55                   	push   %ebp
8010031a:	89 e5                	mov    %esp,%ebp
8010031c:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010031f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100323:	74 1c                	je     80100341 <printint+0x28>
80100325:	8b 45 08             	mov    0x8(%ebp),%eax
80100328:	c1 e8 1f             	shr    $0x1f,%eax
8010032b:	0f b6 c0             	movzbl %al,%eax
8010032e:	89 45 10             	mov    %eax,0x10(%ebp)
80100331:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100335:	74 0a                	je     80100341 <printint+0x28>
    x = -xx;
80100337:	8b 45 08             	mov    0x8(%ebp),%eax
8010033a:	f7 d8                	neg    %eax
8010033c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010033f:	eb 06                	jmp    80100347 <printint+0x2e>
  else
    x = xx;
80100341:	8b 45 08             	mov    0x8(%ebp),%eax
80100344:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100347:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010034e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100351:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100354:	ba 00 00 00 00       	mov    $0x0,%edx
80100359:	f7 f1                	div    %ecx
8010035b:	89 d1                	mov    %edx,%ecx
8010035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100360:	8d 50 01             	lea    0x1(%eax),%edx
80100363:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100366:	0f b6 91 04 90 10 80 	movzbl -0x7fef6ffc(%ecx),%edx
8010036d:	88 54 05 e0          	mov    %dl,-0x20(%ebp,%eax,1)
  }while((x /= base) != 0);
80100371:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100374:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100377:	ba 00 00 00 00       	mov    $0x0,%edx
8010037c:	f7 f1                	div    %ecx
8010037e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100381:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100385:	75 c7                	jne    8010034e <printint+0x35>

  if(sign)
80100387:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038b:	74 2a                	je     801003b7 <printint+0x9e>
    buf[i++] = '-';
8010038d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100390:	8d 50 01             	lea    0x1(%eax),%edx
80100393:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100396:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039b:	eb 1a                	jmp    801003b7 <printint+0x9e>
    consputc(buf[i]);
8010039d:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a3:	01 d0                	add    %edx,%eax
801003a5:	0f b6 00             	movzbl (%eax),%eax
801003a8:	0f be c0             	movsbl %al,%eax
801003ab:	83 ec 0c             	sub    $0xc,%esp
801003ae:	50                   	push   %eax
801003af:	e8 e7 03 00 00       	call   8010079b <consputc>
801003b4:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
801003b7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003bf:	79 dc                	jns    8010039d <printint+0x84>
}
801003c1:	90                   	nop
801003c2:	c9                   	leave  
801003c3:	c3                   	ret    

801003c4 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c4:	55                   	push   %ebp
801003c5:	89 e5                	mov    %esp,%ebp
801003c7:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003ca:	a1 f4 b5 10 80       	mov    0x8010b5f4,%eax
801003cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d6:	74 10                	je     801003e8 <cprintf+0x24>
    acquire(&cons.lock);
801003d8:	83 ec 0c             	sub    $0xc,%esp
801003db:	68 c0 b5 10 80       	push   $0x8010b5c0
801003e0:	e8 5f 4c 00 00       	call   80105044 <acquire>
801003e5:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003e8:	8b 45 08             	mov    0x8(%ebp),%eax
801003eb:	85 c0                	test   %eax,%eax
801003ed:	75 0d                	jne    801003fc <cprintf+0x38>
    panic("null fmt");
801003ef:	83 ec 0c             	sub    $0xc,%esp
801003f2:	68 96 85 10 80       	push   $0x80108596
801003f7:	e8 6b 01 00 00       	call   80100567 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fc:	8d 45 0c             	lea    0xc(%ebp),%eax
801003ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100402:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100409:	e9 1d 01 00 00       	jmp    8010052b <cprintf+0x167>
    if(c != '%'){
8010040e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100412:	74 13                	je     80100427 <cprintf+0x63>
      consputc(c);
80100414:	83 ec 0c             	sub    $0xc,%esp
80100417:	ff 75 e4             	pushl  -0x1c(%ebp)
8010041a:	e8 7c 03 00 00       	call   8010079b <consputc>
8010041f:	83 c4 10             	add    $0x10,%esp
      continue;
80100422:	e9 00 01 00 00       	jmp    80100527 <cprintf+0x163>
    }
    c = fmt[++i] & 0xff;
80100427:	8b 55 08             	mov    0x8(%ebp),%edx
8010042a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010042e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100431:	01 d0                	add    %edx,%eax
80100433:	0f b6 00             	movzbl (%eax),%eax
80100436:	0f be c0             	movsbl %al,%eax
80100439:	25 ff 00 00 00       	and    $0xff,%eax
8010043e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100441:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100445:	0f 84 02 01 00 00    	je     8010054d <cprintf+0x189>
      break;
    switch(c){
8010044b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
8010044f:	74 4c                	je     8010049d <cprintf+0xd9>
80100451:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
80100455:	7f 15                	jg     8010046c <cprintf+0xa8>
80100457:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
8010045b:	0f 84 9b 00 00 00    	je     801004fc <cprintf+0x138>
80100461:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
80100465:	74 16                	je     8010047d <cprintf+0xb9>
80100467:	e9 9f 00 00 00       	jmp    8010050b <cprintf+0x147>
8010046c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
80100470:	74 48                	je     801004ba <cprintf+0xf6>
80100472:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
80100476:	74 25                	je     8010049d <cprintf+0xd9>
80100478:	e9 8e 00 00 00       	jmp    8010050b <cprintf+0x147>
    case 'd':
      printint(*argp++, 10, 1);
8010047d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100480:	8d 50 04             	lea    0x4(%eax),%edx
80100483:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100486:	8b 00                	mov    (%eax),%eax
80100488:	83 ec 04             	sub    $0x4,%esp
8010048b:	6a 01                	push   $0x1
8010048d:	6a 0a                	push   $0xa
8010048f:	50                   	push   %eax
80100490:	e8 84 fe ff ff       	call   80100319 <printint>
80100495:	83 c4 10             	add    $0x10,%esp
      break;
80100498:	e9 8a 00 00 00       	jmp    80100527 <cprintf+0x163>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010049d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004a0:	8d 50 04             	lea    0x4(%eax),%edx
801004a3:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a6:	8b 00                	mov    (%eax),%eax
801004a8:	83 ec 04             	sub    $0x4,%esp
801004ab:	6a 00                	push   $0x0
801004ad:	6a 10                	push   $0x10
801004af:	50                   	push   %eax
801004b0:	e8 64 fe ff ff       	call   80100319 <printint>
801004b5:	83 c4 10             	add    $0x10,%esp
      break;
801004b8:	eb 6d                	jmp    80100527 <cprintf+0x163>
    case 's':
      if((s = (char*)*argp++) == 0)
801004ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004bd:	8d 50 04             	lea    0x4(%eax),%edx
801004c0:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c3:	8b 00                	mov    (%eax),%eax
801004c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004cc:	75 22                	jne    801004f0 <cprintf+0x12c>
        s = "(null)";
801004ce:	c7 45 ec 9f 85 10 80 	movl   $0x8010859f,-0x14(%ebp)
      for(; *s; s++)
801004d5:	eb 19                	jmp    801004f0 <cprintf+0x12c>
        consputc(*s);
801004d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004da:	0f b6 00             	movzbl (%eax),%eax
801004dd:	0f be c0             	movsbl %al,%eax
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	50                   	push   %eax
801004e4:	e8 b2 02 00 00       	call   8010079b <consputc>
801004e9:	83 c4 10             	add    $0x10,%esp
      for(; *s; s++)
801004ec:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004f3:	0f b6 00             	movzbl (%eax),%eax
801004f6:	84 c0                	test   %al,%al
801004f8:	75 dd                	jne    801004d7 <cprintf+0x113>
      break;
801004fa:	eb 2b                	jmp    80100527 <cprintf+0x163>
    case '%':
      consputc('%');
801004fc:	83 ec 0c             	sub    $0xc,%esp
801004ff:	6a 25                	push   $0x25
80100501:	e8 95 02 00 00       	call   8010079b <consputc>
80100506:	83 c4 10             	add    $0x10,%esp
      break;
80100509:	eb 1c                	jmp    80100527 <cprintf+0x163>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010050b:	83 ec 0c             	sub    $0xc,%esp
8010050e:	6a 25                	push   $0x25
80100510:	e8 86 02 00 00       	call   8010079b <consputc>
80100515:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100518:	83 ec 0c             	sub    $0xc,%esp
8010051b:	ff 75 e4             	pushl  -0x1c(%ebp)
8010051e:	e8 78 02 00 00       	call   8010079b <consputc>
80100523:	83 c4 10             	add    $0x10,%esp
      break;
80100526:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100527:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010052b:	8b 55 08             	mov    0x8(%ebp),%edx
8010052e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100531:	01 d0                	add    %edx,%eax
80100533:	0f b6 00             	movzbl (%eax),%eax
80100536:	0f be c0             	movsbl %al,%eax
80100539:	25 ff 00 00 00       	and    $0xff,%eax
8010053e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100541:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100545:	0f 85 c3 fe ff ff    	jne    8010040e <cprintf+0x4a>
8010054b:	eb 01                	jmp    8010054e <cprintf+0x18a>
      break;
8010054d:	90                   	nop
    }
  }

  if(locking)
8010054e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100552:	74 10                	je     80100564 <cprintf+0x1a0>
    release(&cons.lock);
80100554:	83 ec 0c             	sub    $0xc,%esp
80100557:	68 c0 b5 10 80       	push   $0x8010b5c0
8010055c:	e8 4a 4b 00 00       	call   801050ab <release>
80100561:	83 c4 10             	add    $0x10,%esp
}
80100564:	90                   	nop
80100565:	c9                   	leave  
80100566:	c3                   	ret    

80100567 <panic>:

void
panic(char *s)
{
80100567:	55                   	push   %ebp
80100568:	89 e5                	mov    %esp,%ebp
8010056a:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
8010056d:	e8 a0 fd ff ff       	call   80100312 <cli>
  cons.locking = 0;
80100572:	c7 05 f4 b5 10 80 00 	movl   $0x0,0x8010b5f4
80100579:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100582:	0f b6 00             	movzbl (%eax),%eax
80100585:	0f b6 c0             	movzbl %al,%eax
80100588:	83 ec 08             	sub    $0x8,%esp
8010058b:	50                   	push   %eax
8010058c:	68 a6 85 10 80       	push   $0x801085a6
80100591:	e8 2e fe ff ff       	call   801003c4 <cprintf>
80100596:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100599:	8b 45 08             	mov    0x8(%ebp),%eax
8010059c:	83 ec 0c             	sub    $0xc,%esp
8010059f:	50                   	push   %eax
801005a0:	e8 1f fe ff ff       	call   801003c4 <cprintf>
801005a5:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005a8:	83 ec 0c             	sub    $0xc,%esp
801005ab:	68 b5 85 10 80       	push   $0x801085b5
801005b0:	e8 0f fe ff ff       	call   801003c4 <cprintf>
801005b5:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b8:	83 ec 08             	sub    $0x8,%esp
801005bb:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005be:	50                   	push   %eax
801005bf:	8d 45 08             	lea    0x8(%ebp),%eax
801005c2:	50                   	push   %eax
801005c3:	e8 35 4b 00 00       	call   801050fd <getcallerpcs>
801005c8:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d2:	eb 1c                	jmp    801005f0 <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d7:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005db:	83 ec 08             	sub    $0x8,%esp
801005de:	50                   	push   %eax
801005df:	68 b7 85 10 80       	push   $0x801085b7
801005e4:	e8 db fd ff ff       	call   801003c4 <cprintf>
801005e9:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005f0:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005f4:	7e de                	jle    801005d4 <panic+0x6d>
  panicked = 1; // freeze other CPU
801005f6:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
801005fd:	00 00 00 
  for(;;)
80100600:	eb fe                	jmp    80100600 <panic+0x99>

80100602 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100602:	55                   	push   %ebp
80100603:	89 e5                	mov    %esp,%ebp
80100605:	53                   	push   %ebx
80100606:	83 ec 14             	sub    $0x14,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100609:	6a 0e                	push   $0xe
8010060b:	68 d4 03 00 00       	push   $0x3d4
80100610:	e8 dc fc ff ff       	call   801002f1 <outb>
80100615:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100618:	68 d5 03 00 00       	push   $0x3d5
8010061d:	e8 b2 fc ff ff       	call   801002d4 <inb>
80100622:	83 c4 04             	add    $0x4,%esp
80100625:	0f b6 c0             	movzbl %al,%eax
80100628:	c1 e0 08             	shl    $0x8,%eax
8010062b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010062e:	6a 0f                	push   $0xf
80100630:	68 d4 03 00 00       	push   $0x3d4
80100635:	e8 b7 fc ff ff       	call   801002f1 <outb>
8010063a:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
8010063d:	68 d5 03 00 00       	push   $0x3d5
80100642:	e8 8d fc ff ff       	call   801002d4 <inb>
80100647:	83 c4 04             	add    $0x4,%esp
8010064a:	0f b6 c0             	movzbl %al,%eax
8010064d:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100650:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100654:	75 30                	jne    80100686 <cgaputc+0x84>
    pos += 80 - pos%80;
80100656:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100659:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010065e:	89 c8                	mov    %ecx,%eax
80100660:	f7 ea                	imul   %edx
80100662:	c1 fa 05             	sar    $0x5,%edx
80100665:	89 c8                	mov    %ecx,%eax
80100667:	c1 f8 1f             	sar    $0x1f,%eax
8010066a:	29 c2                	sub    %eax,%edx
8010066c:	89 d0                	mov    %edx,%eax
8010066e:	c1 e0 02             	shl    $0x2,%eax
80100671:	01 d0                	add    %edx,%eax
80100673:	c1 e0 04             	shl    $0x4,%eax
80100676:	29 c1                	sub    %eax,%ecx
80100678:	89 ca                	mov    %ecx,%edx
8010067a:	b8 50 00 00 00       	mov    $0x50,%eax
8010067f:	29 d0                	sub    %edx,%eax
80100681:	01 45 f4             	add    %eax,-0xc(%ebp)
80100684:	eb 38                	jmp    801006be <cgaputc+0xbc>
  else if(c == BACKSPACE){
80100686:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010068d:	75 0c                	jne    8010069b <cgaputc+0x99>
    if(pos > 0) --pos;
8010068f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100693:	7e 29                	jle    801006be <cgaputc+0xbc>
80100695:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100699:	eb 23                	jmp    801006be <cgaputc+0xbc>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010069b:	8b 45 08             	mov    0x8(%ebp),%eax
8010069e:	0f b6 c0             	movzbl %al,%eax
801006a1:	80 cc 07             	or     $0x7,%ah
801006a4:	89 c3                	mov    %eax,%ebx
801006a6:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
801006ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006af:	8d 50 01             	lea    0x1(%eax),%edx
801006b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006b5:	01 c0                	add    %eax,%eax
801006b7:	01 c8                	add    %ecx,%eax
801006b9:	89 da                	mov    %ebx,%edx
801006bb:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
801006be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006c2:	78 09                	js     801006cd <cgaputc+0xcb>
801006c4:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006cb:	7e 0d                	jle    801006da <cgaputc+0xd8>
    panic("pos under/overflow");
801006cd:	83 ec 0c             	sub    $0xc,%esp
801006d0:	68 bb 85 10 80       	push   $0x801085bb
801006d5:	e8 8d fe ff ff       	call   80100567 <panic>
  
  if((pos/80) >= 24){  // Scroll up.
801006da:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006e1:	7e 4c                	jle    8010072f <cgaputc+0x12d>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006e3:	a1 00 90 10 80       	mov    0x80109000,%eax
801006e8:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006ee:	a1 00 90 10 80       	mov    0x80109000,%eax
801006f3:	83 ec 04             	sub    $0x4,%esp
801006f6:	68 60 0e 00 00       	push   $0xe60
801006fb:	52                   	push   %edx
801006fc:	50                   	push   %eax
801006fd:	e8 64 4c 00 00       	call   80105366 <memmove>
80100702:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
80100705:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100709:	b8 80 07 00 00       	mov    $0x780,%eax
8010070e:	2b 45 f4             	sub    -0xc(%ebp),%eax
80100711:	8d 14 00             	lea    (%eax,%eax,1),%edx
80100714:	a1 00 90 10 80       	mov    0x80109000,%eax
80100719:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010071c:	01 c9                	add    %ecx,%ecx
8010071e:	01 c8                	add    %ecx,%eax
80100720:	83 ec 04             	sub    $0x4,%esp
80100723:	52                   	push   %edx
80100724:	6a 00                	push   $0x0
80100726:	50                   	push   %eax
80100727:	e8 7b 4b 00 00       	call   801052a7 <memset>
8010072c:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
8010072f:	83 ec 08             	sub    $0x8,%esp
80100732:	6a 0e                	push   $0xe
80100734:	68 d4 03 00 00       	push   $0x3d4
80100739:	e8 b3 fb ff ff       	call   801002f1 <outb>
8010073e:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
80100741:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100744:	c1 f8 08             	sar    $0x8,%eax
80100747:	0f b6 c0             	movzbl %al,%eax
8010074a:	83 ec 08             	sub    $0x8,%esp
8010074d:	50                   	push   %eax
8010074e:	68 d5 03 00 00       	push   $0x3d5
80100753:	e8 99 fb ff ff       	call   801002f1 <outb>
80100758:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
8010075b:	83 ec 08             	sub    $0x8,%esp
8010075e:	6a 0f                	push   $0xf
80100760:	68 d4 03 00 00       	push   $0x3d4
80100765:	e8 87 fb ff ff       	call   801002f1 <outb>
8010076a:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
8010076d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100770:	0f b6 c0             	movzbl %al,%eax
80100773:	83 ec 08             	sub    $0x8,%esp
80100776:	50                   	push   %eax
80100777:	68 d5 03 00 00       	push   $0x3d5
8010077c:	e8 70 fb ff ff       	call   801002f1 <outb>
80100781:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
80100784:	a1 00 90 10 80       	mov    0x80109000,%eax
80100789:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010078c:	01 d2                	add    %edx,%edx
8010078e:	01 d0                	add    %edx,%eax
80100790:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100795:	90                   	nop
80100796:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100799:	c9                   	leave  
8010079a:	c3                   	ret    

8010079b <consputc>:

void
consputc(int c)
{
8010079b:	55                   	push   %ebp
8010079c:	89 e5                	mov    %esp,%ebp
8010079e:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
801007a1:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
801007a6:	85 c0                	test   %eax,%eax
801007a8:	74 07                	je     801007b1 <consputc+0x16>
    cli();
801007aa:	e8 63 fb ff ff       	call   80100312 <cli>
    for(;;)
801007af:	eb fe                	jmp    801007af <consputc+0x14>
      ;
  }

  if(c == BACKSPACE){
801007b1:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007b8:	75 29                	jne    801007e3 <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007ba:	83 ec 0c             	sub    $0xc,%esp
801007bd:	6a 08                	push   $0x8
801007bf:	e8 32 64 00 00       	call   80106bf6 <uartputc>
801007c4:	83 c4 10             	add    $0x10,%esp
801007c7:	83 ec 0c             	sub    $0xc,%esp
801007ca:	6a 20                	push   $0x20
801007cc:	e8 25 64 00 00       	call   80106bf6 <uartputc>
801007d1:	83 c4 10             	add    $0x10,%esp
801007d4:	83 ec 0c             	sub    $0xc,%esp
801007d7:	6a 08                	push   $0x8
801007d9:	e8 18 64 00 00       	call   80106bf6 <uartputc>
801007de:	83 c4 10             	add    $0x10,%esp
801007e1:	eb 0e                	jmp    801007f1 <consputc+0x56>
  } else
    uartputc(c);
801007e3:	83 ec 0c             	sub    $0xc,%esp
801007e6:	ff 75 08             	pushl  0x8(%ebp)
801007e9:	e8 08 64 00 00       	call   80106bf6 <uartputc>
801007ee:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007f1:	83 ec 0c             	sub    $0xc,%esp
801007f4:	ff 75 08             	pushl  0x8(%ebp)
801007f7:	e8 06 fe ff ff       	call   80100602 <cgaputc>
801007fc:	83 c4 10             	add    $0x10,%esp
}
801007ff:	90                   	nop
80100800:	c9                   	leave  
80100801:	c3                   	ret    

80100802 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100802:	55                   	push   %ebp
80100803:	89 e5                	mov    %esp,%ebp
80100805:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
80100808:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
8010080f:	83 ec 0c             	sub    $0xc,%esp
80100812:	68 c0 b5 10 80       	push   $0x8010b5c0
80100817:	e8 28 48 00 00       	call   80105044 <acquire>
8010081c:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
8010081f:	e9 46 01 00 00       	jmp    8010096a <consoleintr+0x168>
    switch(c){
80100824:	83 7d f0 10          	cmpl   $0x10,-0x10(%ebp)
80100828:	74 22                	je     8010084c <consoleintr+0x4a>
8010082a:	83 7d f0 10          	cmpl   $0x10,-0x10(%ebp)
8010082e:	7f 0b                	jg     8010083b <consoleintr+0x39>
80100830:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
80100834:	74 6d                	je     801008a3 <consoleintr+0xa1>
80100836:	e9 9d 00 00 00       	jmp    801008d8 <consoleintr+0xd6>
8010083b:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
8010083f:	74 34                	je     80100875 <consoleintr+0x73>
80100841:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80100845:	74 5c                	je     801008a3 <consoleintr+0xa1>
80100847:	e9 8c 00 00 00       	jmp    801008d8 <consoleintr+0xd6>
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
8010084c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100853:	e9 12 01 00 00       	jmp    8010096a <consoleintr+0x168>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100858:	a1 08 08 11 80       	mov    0x80110808,%eax
8010085d:	83 e8 01             	sub    $0x1,%eax
80100860:	a3 08 08 11 80       	mov    %eax,0x80110808
        consputc(BACKSPACE);
80100865:	83 ec 0c             	sub    $0xc,%esp
80100868:	68 00 01 00 00       	push   $0x100
8010086d:	e8 29 ff ff ff       	call   8010079b <consputc>
80100872:	83 c4 10             	add    $0x10,%esp
      while(input.e != input.w &&
80100875:	8b 15 08 08 11 80    	mov    0x80110808,%edx
8010087b:	a1 04 08 11 80       	mov    0x80110804,%eax
80100880:	39 c2                	cmp    %eax,%edx
80100882:	0f 84 e2 00 00 00    	je     8010096a <consoleintr+0x168>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100888:	a1 08 08 11 80       	mov    0x80110808,%eax
8010088d:	83 e8 01             	sub    $0x1,%eax
80100890:	83 e0 7f             	and    $0x7f,%eax
80100893:	0f b6 80 80 07 11 80 	movzbl -0x7feef880(%eax),%eax
      while(input.e != input.w &&
8010089a:	3c 0a                	cmp    $0xa,%al
8010089c:	75 ba                	jne    80100858 <consoleintr+0x56>
      }
      break;
8010089e:	e9 c7 00 00 00       	jmp    8010096a <consoleintr+0x168>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801008a3:	8b 15 08 08 11 80    	mov    0x80110808,%edx
801008a9:	a1 04 08 11 80       	mov    0x80110804,%eax
801008ae:	39 c2                	cmp    %eax,%edx
801008b0:	0f 84 b4 00 00 00    	je     8010096a <consoleintr+0x168>
        input.e--;
801008b6:	a1 08 08 11 80       	mov    0x80110808,%eax
801008bb:	83 e8 01             	sub    $0x1,%eax
801008be:	a3 08 08 11 80       	mov    %eax,0x80110808
        consputc(BACKSPACE);
801008c3:	83 ec 0c             	sub    $0xc,%esp
801008c6:	68 00 01 00 00       	push   $0x100
801008cb:	e8 cb fe ff ff       	call   8010079b <consputc>
801008d0:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008d3:	e9 92 00 00 00       	jmp    8010096a <consoleintr+0x168>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801008dc:	0f 84 87 00 00 00    	je     80100969 <consoleintr+0x167>
801008e2:	8b 15 08 08 11 80    	mov    0x80110808,%edx
801008e8:	a1 00 08 11 80       	mov    0x80110800,%eax
801008ed:	29 c2                	sub    %eax,%edx
801008ef:	89 d0                	mov    %edx,%eax
801008f1:	83 f8 7f             	cmp    $0x7f,%eax
801008f4:	77 73                	ja     80100969 <consoleintr+0x167>
        c = (c == '\r') ? '\n' : c;
801008f6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801008fa:	74 05                	je     80100901 <consoleintr+0xff>
801008fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008ff:	eb 05                	jmp    80100906 <consoleintr+0x104>
80100901:	b8 0a 00 00 00       	mov    $0xa,%eax
80100906:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100909:	a1 08 08 11 80       	mov    0x80110808,%eax
8010090e:	8d 50 01             	lea    0x1(%eax),%edx
80100911:	89 15 08 08 11 80    	mov    %edx,0x80110808
80100917:	83 e0 7f             	and    $0x7f,%eax
8010091a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010091d:	88 90 80 07 11 80    	mov    %dl,-0x7feef880(%eax)
        consputc(c);
80100923:	83 ec 0c             	sub    $0xc,%esp
80100926:	ff 75 f0             	pushl  -0x10(%ebp)
80100929:	e8 6d fe ff ff       	call   8010079b <consputc>
8010092e:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100931:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100935:	74 18                	je     8010094f <consoleintr+0x14d>
80100937:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
8010093b:	74 12                	je     8010094f <consoleintr+0x14d>
8010093d:	a1 08 08 11 80       	mov    0x80110808,%eax
80100942:	8b 15 00 08 11 80    	mov    0x80110800,%edx
80100948:	83 ea 80             	sub    $0xffffff80,%edx
8010094b:	39 d0                	cmp    %edx,%eax
8010094d:	75 1a                	jne    80100969 <consoleintr+0x167>
          input.w = input.e;
8010094f:	a1 08 08 11 80       	mov    0x80110808,%eax
80100954:	a3 04 08 11 80       	mov    %eax,0x80110804
          wakeup(&input.r);
80100959:	83 ec 0c             	sub    $0xc,%esp
8010095c:	68 00 08 11 80       	push   $0x80110800
80100961:	e8 d0 44 00 00       	call   80104e36 <wakeup>
80100966:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100969:	90                   	nop
  while((c = getc()) >= 0){
8010096a:	8b 45 08             	mov    0x8(%ebp),%eax
8010096d:	ff d0                	call   *%eax
8010096f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100972:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100976:	0f 89 a8 fe ff ff    	jns    80100824 <consoleintr+0x22>
    }
  }
  release(&cons.lock);
8010097c:	83 ec 0c             	sub    $0xc,%esp
8010097f:	68 c0 b5 10 80       	push   $0x8010b5c0
80100984:	e8 22 47 00 00       	call   801050ab <release>
80100989:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
8010098c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100990:	74 05                	je     80100997 <consoleintr+0x195>
    procdump();  // now call procdump() wo. cons.lock held
80100992:	e8 5a 45 00 00       	call   80104ef1 <procdump>
  }
}
80100997:	90                   	nop
80100998:	c9                   	leave  
80100999:	c3                   	ret    

8010099a <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010099a:	55                   	push   %ebp
8010099b:	89 e5                	mov    %esp,%ebp
8010099d:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
801009a0:	83 ec 0c             	sub    $0xc,%esp
801009a3:	ff 75 08             	pushl  0x8(%ebp)
801009a6:	e8 28 11 00 00       	call   80101ad3 <iunlock>
801009ab:	83 c4 10             	add    $0x10,%esp
  target = n;
801009ae:	8b 45 10             	mov    0x10(%ebp),%eax
801009b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
801009b4:	83 ec 0c             	sub    $0xc,%esp
801009b7:	68 c0 b5 10 80       	push   $0x8010b5c0
801009bc:	e8 83 46 00 00       	call   80105044 <acquire>
801009c1:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009c4:	e9 ac 00 00 00       	jmp    80100a75 <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
801009c9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801009cf:	8b 40 24             	mov    0x24(%eax),%eax
801009d2:	85 c0                	test   %eax,%eax
801009d4:	74 28                	je     801009fe <consoleread+0x64>
        release(&cons.lock);
801009d6:	83 ec 0c             	sub    $0xc,%esp
801009d9:	68 c0 b5 10 80       	push   $0x8010b5c0
801009de:	e8 c8 46 00 00       	call   801050ab <release>
801009e3:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
801009e6:	83 ec 0c             	sub    $0xc,%esp
801009e9:	ff 75 08             	pushl  0x8(%ebp)
801009ec:	e8 84 0f 00 00       	call   80101975 <ilock>
801009f1:	83 c4 10             	add    $0x10,%esp
        return -1;
801009f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009f9:	e9 ab 00 00 00       	jmp    80100aa9 <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
801009fe:	83 ec 08             	sub    $0x8,%esp
80100a01:	68 c0 b5 10 80       	push   $0x8010b5c0
80100a06:	68 00 08 11 80       	push   $0x80110800
80100a0b:	e8 3b 43 00 00       	call   80104d4b <sleep>
80100a10:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
80100a13:	8b 15 00 08 11 80    	mov    0x80110800,%edx
80100a19:	a1 04 08 11 80       	mov    0x80110804,%eax
80100a1e:	39 c2                	cmp    %eax,%edx
80100a20:	74 a7                	je     801009c9 <consoleread+0x2f>
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a22:	a1 00 08 11 80       	mov    0x80110800,%eax
80100a27:	8d 50 01             	lea    0x1(%eax),%edx
80100a2a:	89 15 00 08 11 80    	mov    %edx,0x80110800
80100a30:	83 e0 7f             	and    $0x7f,%eax
80100a33:	0f b6 80 80 07 11 80 	movzbl -0x7feef880(%eax),%eax
80100a3a:	0f be c0             	movsbl %al,%eax
80100a3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a40:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a44:	75 17                	jne    80100a5d <consoleread+0xc3>
      if(n < target){
80100a46:	8b 45 10             	mov    0x10(%ebp),%eax
80100a49:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100a4c:	76 2f                	jbe    80100a7d <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a4e:	a1 00 08 11 80       	mov    0x80110800,%eax
80100a53:	83 e8 01             	sub    $0x1,%eax
80100a56:	a3 00 08 11 80       	mov    %eax,0x80110800
      }
      break;
80100a5b:	eb 20                	jmp    80100a7d <consoleread+0xe3>
    }
    *dst++ = c;
80100a5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a60:	8d 50 01             	lea    0x1(%eax),%edx
80100a63:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a66:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a69:	88 10                	mov    %dl,(%eax)
    --n;
80100a6b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a6f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a73:	74 0b                	je     80100a80 <consoleread+0xe6>
  while(n > 0){
80100a75:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a79:	7f 98                	jg     80100a13 <consoleread+0x79>
80100a7b:	eb 04                	jmp    80100a81 <consoleread+0xe7>
      break;
80100a7d:	90                   	nop
80100a7e:	eb 01                	jmp    80100a81 <consoleread+0xe7>
      break;
80100a80:	90                   	nop
  }
  release(&cons.lock);
80100a81:	83 ec 0c             	sub    $0xc,%esp
80100a84:	68 c0 b5 10 80       	push   $0x8010b5c0
80100a89:	e8 1d 46 00 00       	call   801050ab <release>
80100a8e:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a91:	83 ec 0c             	sub    $0xc,%esp
80100a94:	ff 75 08             	pushl  0x8(%ebp)
80100a97:	e8 d9 0e 00 00       	call   80101975 <ilock>
80100a9c:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100a9f:	8b 45 10             	mov    0x10(%ebp),%eax
80100aa2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100aa5:	29 c2                	sub    %eax,%edx
80100aa7:	89 d0                	mov    %edx,%eax
}
80100aa9:	c9                   	leave  
80100aaa:	c3                   	ret    

80100aab <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100aab:	55                   	push   %ebp
80100aac:	89 e5                	mov    %esp,%ebp
80100aae:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100ab1:	83 ec 0c             	sub    $0xc,%esp
80100ab4:	ff 75 08             	pushl  0x8(%ebp)
80100ab7:	e8 17 10 00 00       	call   80101ad3 <iunlock>
80100abc:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100abf:	83 ec 0c             	sub    $0xc,%esp
80100ac2:	68 c0 b5 10 80       	push   $0x8010b5c0
80100ac7:	e8 78 45 00 00       	call   80105044 <acquire>
80100acc:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100acf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100ad6:	eb 21                	jmp    80100af9 <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100ad8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100adb:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ade:	01 d0                	add    %edx,%eax
80100ae0:	0f b6 00             	movzbl (%eax),%eax
80100ae3:	0f be c0             	movsbl %al,%eax
80100ae6:	0f b6 c0             	movzbl %al,%eax
80100ae9:	83 ec 0c             	sub    $0xc,%esp
80100aec:	50                   	push   %eax
80100aed:	e8 a9 fc ff ff       	call   8010079b <consputc>
80100af2:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100af5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100afc:	3b 45 10             	cmp    0x10(%ebp),%eax
80100aff:	7c d7                	jl     80100ad8 <consolewrite+0x2d>
  release(&cons.lock);
80100b01:	83 ec 0c             	sub    $0xc,%esp
80100b04:	68 c0 b5 10 80       	push   $0x8010b5c0
80100b09:	e8 9d 45 00 00       	call   801050ab <release>
80100b0e:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff 75 08             	pushl  0x8(%ebp)
80100b17:	e8 59 0e 00 00       	call   80101975 <ilock>
80100b1c:	83 c4 10             	add    $0x10,%esp

  return n;
80100b1f:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b22:	c9                   	leave  
80100b23:	c3                   	ret    

80100b24 <consoleinit>:

void
consoleinit(void)
{
80100b24:	55                   	push   %ebp
80100b25:	89 e5                	mov    %esp,%ebp
80100b27:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100b2a:	83 ec 08             	sub    $0x8,%esp
80100b2d:	68 ce 85 10 80       	push   $0x801085ce
80100b32:	68 c0 b5 10 80       	push   $0x8010b5c0
80100b37:	e8 e6 44 00 00       	call   80105022 <initlock>
80100b3c:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b3f:	c7 05 cc 11 11 80 ab 	movl   $0x80100aab,0x801111cc
80100b46:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b49:	c7 05 c8 11 11 80 9a 	movl   $0x8010099a,0x801111c8
80100b50:	09 10 80 
  cons.locking = 1;
80100b53:	c7 05 f4 b5 10 80 01 	movl   $0x1,0x8010b5f4
80100b5a:	00 00 00 

  picenable(IRQ_KBD);
80100b5d:	83 ec 0c             	sub    $0xc,%esp
80100b60:	6a 01                	push   $0x1
80100b62:	e8 d9 33 00 00       	call   80103f40 <picenable>
80100b67:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b6a:	83 ec 08             	sub    $0x8,%esp
80100b6d:	6a 00                	push   $0x0
80100b6f:	6a 01                	push   $0x1
80100b71:	e8 68 1f 00 00       	call   80102ade <ioapicenable>
80100b76:	83 c4 10             	add    $0x10,%esp
}
80100b79:	90                   	nop
80100b7a:	c9                   	leave  
80100b7b:	c3                   	ret    

80100b7c <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b7c:	55                   	push   %ebp
80100b7d:	89 e5                	mov    %esp,%ebp
80100b7f:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100b85:	e8 cc 29 00 00       	call   80103556 <begin_op>
  if((ip = namei(path)) == 0){
80100b8a:	83 ec 0c             	sub    $0xc,%esp
80100b8d:	ff 75 08             	pushl  0x8(%ebp)
80100b90:	e8 95 19 00 00       	call   8010252a <namei>
80100b95:	83 c4 10             	add    $0x10,%esp
80100b98:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b9b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b9f:	75 0f                	jne    80100bb0 <exec+0x34>
    end_op();
80100ba1:	e8 3c 2a 00 00       	call   801035e2 <end_op>
    return -1;
80100ba6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bab:	e9 ce 03 00 00       	jmp    80100f7e <exec+0x402>
  }
  ilock(ip);
80100bb0:	83 ec 0c             	sub    $0xc,%esp
80100bb3:	ff 75 d8             	pushl  -0x28(%ebp)
80100bb6:	e8 ba 0d 00 00       	call   80101975 <ilock>
80100bbb:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100bbe:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100bc5:	6a 34                	push   $0x34
80100bc7:	6a 00                	push   $0x0
80100bc9:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100bcf:	50                   	push   %eax
80100bd0:	ff 75 d8             	pushl  -0x28(%ebp)
80100bd3:	e8 06 13 00 00       	call   80101ede <readi>
80100bd8:	83 c4 10             	add    $0x10,%esp
80100bdb:	83 f8 33             	cmp    $0x33,%eax
80100bde:	0f 86 49 03 00 00    	jbe    80100f2d <exec+0x3b1>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100be4:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bea:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100bef:	0f 85 3b 03 00 00    	jne    80100f30 <exec+0x3b4>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100bf5:	e8 51 71 00 00       	call   80107d4b <setupkvm>
80100bfa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100bfd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c01:	0f 84 2c 03 00 00    	je     80100f33 <exec+0x3b7>
    goto bad;

  // Load program into memory.
  sz = 0;
80100c07:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c0e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c15:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100c1b:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c1e:	e9 ab 00 00 00       	jmp    80100cce <exec+0x152>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c23:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c26:	6a 20                	push   $0x20
80100c28:	50                   	push   %eax
80100c29:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100c2f:	50                   	push   %eax
80100c30:	ff 75 d8             	pushl  -0x28(%ebp)
80100c33:	e8 a6 12 00 00       	call   80101ede <readi>
80100c38:	83 c4 10             	add    $0x10,%esp
80100c3b:	83 f8 20             	cmp    $0x20,%eax
80100c3e:	0f 85 f2 02 00 00    	jne    80100f36 <exec+0x3ba>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c44:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c4a:	83 f8 01             	cmp    $0x1,%eax
80100c4d:	75 71                	jne    80100cc0 <exec+0x144>
      continue;
    if(ph.memsz < ph.filesz)
80100c4f:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c55:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c5b:	39 c2                	cmp    %eax,%edx
80100c5d:	0f 82 d6 02 00 00    	jb     80100f39 <exec+0x3bd>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c63:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c69:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c6f:	01 d0                	add    %edx,%eax
80100c71:	83 ec 04             	sub    $0x4,%esp
80100c74:	50                   	push   %eax
80100c75:	ff 75 e0             	pushl  -0x20(%ebp)
80100c78:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c7b:	e8 73 74 00 00       	call   801080f3 <allocuvm>
80100c80:	83 c4 10             	add    $0x10,%esp
80100c83:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c86:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c8a:	0f 84 ac 02 00 00    	je     80100f3c <exec+0x3c0>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c90:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c96:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c9c:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100ca2:	83 ec 0c             	sub    $0xc,%esp
80100ca5:	52                   	push   %edx
80100ca6:	50                   	push   %eax
80100ca7:	ff 75 d8             	pushl  -0x28(%ebp)
80100caa:	51                   	push   %ecx
80100cab:	ff 75 d4             	pushl  -0x2c(%ebp)
80100cae:	e8 69 73 00 00       	call   8010801c <loaduvm>
80100cb3:	83 c4 20             	add    $0x20,%esp
80100cb6:	85 c0                	test   %eax,%eax
80100cb8:	0f 88 81 02 00 00    	js     80100f3f <exec+0x3c3>
80100cbe:	eb 01                	jmp    80100cc1 <exec+0x145>
      continue;
80100cc0:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cc1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100cc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cc8:	83 c0 20             	add    $0x20,%eax
80100ccb:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cce:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100cd5:	0f b7 c0             	movzwl %ax,%eax
80100cd8:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80100cdb:	0f 8c 42 ff ff ff    	jl     80100c23 <exec+0xa7>
      goto bad;
  }
  iunlockput(ip);
80100ce1:	83 ec 0c             	sub    $0xc,%esp
80100ce4:	ff 75 d8             	pushl  -0x28(%ebp)
80100ce7:	e8 49 0f 00 00       	call   80101c35 <iunlockput>
80100cec:	83 c4 10             	add    $0x10,%esp
  end_op();
80100cef:	e8 ee 28 00 00       	call   801035e2 <end_op>
  ip = 0;
80100cf4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cfe:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d03:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d08:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d0e:	05 00 20 00 00       	add    $0x2000,%eax
80100d13:	83 ec 04             	sub    $0x4,%esp
80100d16:	50                   	push   %eax
80100d17:	ff 75 e0             	pushl  -0x20(%ebp)
80100d1a:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d1d:	e8 d1 73 00 00       	call   801080f3 <allocuvm>
80100d22:	83 c4 10             	add    $0x10,%esp
80100d25:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d28:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d2c:	0f 84 10 02 00 00    	je     80100f42 <exec+0x3c6>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d32:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d35:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d3a:	83 ec 08             	sub    $0x8,%esp
80100d3d:	50                   	push   %eax
80100d3e:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d41:	e8 d3 75 00 00       	call   80108319 <clearpteu>
80100d46:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100d49:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d4c:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d4f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d56:	e9 96 00 00 00       	jmp    80100df1 <exec+0x275>
    if(argc >= MAXARG)
80100d5b:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d5f:	0f 87 e0 01 00 00    	ja     80100f45 <exec+0x3c9>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d68:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d72:	01 d0                	add    %edx,%eax
80100d74:	8b 00                	mov    (%eax),%eax
80100d76:	83 ec 0c             	sub    $0xc,%esp
80100d79:	50                   	push   %eax
80100d7a:	e8 75 47 00 00       	call   801054f4 <strlen>
80100d7f:	83 c4 10             	add    $0x10,%esp
80100d82:	89 c2                	mov    %eax,%edx
80100d84:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d87:	29 d0                	sub    %edx,%eax
80100d89:	83 e8 01             	sub    $0x1,%eax
80100d8c:	83 e0 fc             	and    $0xfffffffc,%eax
80100d8f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d95:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d9f:	01 d0                	add    %edx,%eax
80100da1:	8b 00                	mov    (%eax),%eax
80100da3:	83 ec 0c             	sub    $0xc,%esp
80100da6:	50                   	push   %eax
80100da7:	e8 48 47 00 00       	call   801054f4 <strlen>
80100dac:	83 c4 10             	add    $0x10,%esp
80100daf:	83 c0 01             	add    $0x1,%eax
80100db2:	89 c1                	mov    %eax,%ecx
80100db4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100db7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dc1:	01 d0                	add    %edx,%eax
80100dc3:	8b 00                	mov    (%eax),%eax
80100dc5:	51                   	push   %ecx
80100dc6:	50                   	push   %eax
80100dc7:	ff 75 dc             	pushl  -0x24(%ebp)
80100dca:	ff 75 d4             	pushl  -0x2c(%ebp)
80100dcd:	e8 ff 76 00 00       	call   801084d1 <copyout>
80100dd2:	83 c4 10             	add    $0x10,%esp
80100dd5:	85 c0                	test   %eax,%eax
80100dd7:	0f 88 6b 01 00 00    	js     80100f48 <exec+0x3cc>
      goto bad;
    ustack[3+argc] = sp;
80100ddd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de0:	8d 50 03             	lea    0x3(%eax),%edx
80100de3:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100de6:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100ded:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100df1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dfe:	01 d0                	add    %edx,%eax
80100e00:	8b 00                	mov    (%eax),%eax
80100e02:	85 c0                	test   %eax,%eax
80100e04:	0f 85 51 ff ff ff    	jne    80100d5b <exec+0x1df>
  }
  ustack[3+argc] = 0;
80100e0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e0d:	83 c0 03             	add    $0x3,%eax
80100e10:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100e17:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e1b:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100e22:	ff ff ff 
  ustack[1] = argc;
80100e25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e28:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e31:	83 c0 01             	add    $0x1,%eax
80100e34:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e3e:	29 d0                	sub    %edx,%eax
80100e40:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e49:	83 c0 04             	add    $0x4,%eax
80100e4c:	c1 e0 02             	shl    $0x2,%eax
80100e4f:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e55:	83 c0 04             	add    $0x4,%eax
80100e58:	c1 e0 02             	shl    $0x2,%eax
80100e5b:	50                   	push   %eax
80100e5c:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e62:	50                   	push   %eax
80100e63:	ff 75 dc             	pushl  -0x24(%ebp)
80100e66:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e69:	e8 63 76 00 00       	call   801084d1 <copyout>
80100e6e:	83 c4 10             	add    $0x10,%esp
80100e71:	85 c0                	test   %eax,%eax
80100e73:	0f 88 d2 00 00 00    	js     80100f4b <exec+0x3cf>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e79:	8b 45 08             	mov    0x8(%ebp),%eax
80100e7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e82:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e85:	eb 17                	jmp    80100e9e <exec+0x322>
    if(*s == '/')
80100e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e8a:	0f b6 00             	movzbl (%eax),%eax
80100e8d:	3c 2f                	cmp    $0x2f,%al
80100e8f:	75 09                	jne    80100e9a <exec+0x31e>
      last = s+1;
80100e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e94:	83 c0 01             	add    $0x1,%eax
80100e97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(last=s=path; *s; s++)
80100e9a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ea1:	0f b6 00             	movzbl (%eax),%eax
80100ea4:	84 c0                	test   %al,%al
80100ea6:	75 df                	jne    80100e87 <exec+0x30b>
  safestrcpy(proc->name, last, sizeof(proc->name));
80100ea8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eae:	83 c0 6c             	add    $0x6c,%eax
80100eb1:	83 ec 04             	sub    $0x4,%esp
80100eb4:	6a 10                	push   $0x10
80100eb6:	ff 75 f0             	pushl  -0x10(%ebp)
80100eb9:	50                   	push   %eax
80100eba:	e8 eb 45 00 00       	call   801054aa <safestrcpy>
80100ebf:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100ec2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec8:	8b 40 04             	mov    0x4(%eax),%eax
80100ecb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100ece:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100ed7:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100eda:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ee3:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100ee5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eeb:	8b 40 18             	mov    0x18(%eax),%eax
80100eee:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100ef4:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100ef7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100efd:	8b 40 18             	mov    0x18(%eax),%eax
80100f00:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f03:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100f06:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f0c:	83 ec 0c             	sub    $0xc,%esp
80100f0f:	50                   	push   %eax
80100f10:	e8 1d 6f 00 00       	call   80107e32 <switchuvm>
80100f15:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f18:	83 ec 0c             	sub    $0xc,%esp
80100f1b:	ff 75 d0             	pushl  -0x30(%ebp)
80100f1e:	e8 56 73 00 00       	call   80108279 <freevm>
80100f23:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f26:	b8 00 00 00 00       	mov    $0x0,%eax
80100f2b:	eb 51                	jmp    80100f7e <exec+0x402>
    goto bad;
80100f2d:	90                   	nop
80100f2e:	eb 1c                	jmp    80100f4c <exec+0x3d0>
    goto bad;
80100f30:	90                   	nop
80100f31:	eb 19                	jmp    80100f4c <exec+0x3d0>
    goto bad;
80100f33:	90                   	nop
80100f34:	eb 16                	jmp    80100f4c <exec+0x3d0>
      goto bad;
80100f36:	90                   	nop
80100f37:	eb 13                	jmp    80100f4c <exec+0x3d0>
      goto bad;
80100f39:	90                   	nop
80100f3a:	eb 10                	jmp    80100f4c <exec+0x3d0>
      goto bad;
80100f3c:	90                   	nop
80100f3d:	eb 0d                	jmp    80100f4c <exec+0x3d0>
      goto bad;
80100f3f:	90                   	nop
80100f40:	eb 0a                	jmp    80100f4c <exec+0x3d0>
    goto bad;
80100f42:	90                   	nop
80100f43:	eb 07                	jmp    80100f4c <exec+0x3d0>
      goto bad;
80100f45:	90                   	nop
80100f46:	eb 04                	jmp    80100f4c <exec+0x3d0>
      goto bad;
80100f48:	90                   	nop
80100f49:	eb 01                	jmp    80100f4c <exec+0x3d0>
    goto bad;
80100f4b:	90                   	nop

 bad:
  if(pgdir)
80100f4c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f50:	74 0e                	je     80100f60 <exec+0x3e4>
    freevm(pgdir);
80100f52:	83 ec 0c             	sub    $0xc,%esp
80100f55:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f58:	e8 1c 73 00 00       	call   80108279 <freevm>
80100f5d:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100f60:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f64:	74 13                	je     80100f79 <exec+0x3fd>
    iunlockput(ip);
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	ff 75 d8             	pushl  -0x28(%ebp)
80100f6c:	e8 c4 0c 00 00       	call   80101c35 <iunlockput>
80100f71:	83 c4 10             	add    $0x10,%esp
    end_op();
80100f74:	e8 69 26 00 00       	call   801035e2 <end_op>
  }
  return -1;
80100f79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f7e:	c9                   	leave  
80100f7f:	c3                   	ret    

80100f80 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f80:	55                   	push   %ebp
80100f81:	89 e5                	mov    %esp,%ebp
80100f83:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100f86:	83 ec 08             	sub    $0x8,%esp
80100f89:	68 d6 85 10 80       	push   $0x801085d6
80100f8e:	68 20 08 11 80       	push   $0x80110820
80100f93:	e8 8a 40 00 00       	call   80105022 <initlock>
80100f98:	83 c4 10             	add    $0x10,%esp
}
80100f9b:	90                   	nop
80100f9c:	c9                   	leave  
80100f9d:	c3                   	ret    

80100f9e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f9e:	55                   	push   %ebp
80100f9f:	89 e5                	mov    %esp,%ebp
80100fa1:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100fa4:	83 ec 0c             	sub    $0xc,%esp
80100fa7:	68 20 08 11 80       	push   $0x80110820
80100fac:	e8 93 40 00 00       	call   80105044 <acquire>
80100fb1:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fb4:	c7 45 f4 54 08 11 80 	movl   $0x80110854,-0xc(%ebp)
80100fbb:	eb 2d                	jmp    80100fea <filealloc+0x4c>
    if(f->ref == 0){
80100fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fc0:	8b 40 04             	mov    0x4(%eax),%eax
80100fc3:	85 c0                	test   %eax,%eax
80100fc5:	75 1f                	jne    80100fe6 <filealloc+0x48>
      f->ref = 1;
80100fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fca:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100fd1:	83 ec 0c             	sub    $0xc,%esp
80100fd4:	68 20 08 11 80       	push   $0x80110820
80100fd9:	e8 cd 40 00 00       	call   801050ab <release>
80100fde:	83 c4 10             	add    $0x10,%esp
      return f;
80100fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fe4:	eb 23                	jmp    80101009 <filealloc+0x6b>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fe6:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100fea:	b8 b4 11 11 80       	mov    $0x801111b4,%eax
80100fef:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100ff2:	72 c9                	jb     80100fbd <filealloc+0x1f>
    }
  }
  release(&ftable.lock);
80100ff4:	83 ec 0c             	sub    $0xc,%esp
80100ff7:	68 20 08 11 80       	push   $0x80110820
80100ffc:	e8 aa 40 00 00       	call   801050ab <release>
80101001:	83 c4 10             	add    $0x10,%esp
  return 0;
80101004:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101009:	c9                   	leave  
8010100a:	c3                   	ret    

8010100b <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
8010100b:	55                   	push   %ebp
8010100c:	89 e5                	mov    %esp,%ebp
8010100e:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101011:	83 ec 0c             	sub    $0xc,%esp
80101014:	68 20 08 11 80       	push   $0x80110820
80101019:	e8 26 40 00 00       	call   80105044 <acquire>
8010101e:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101021:	8b 45 08             	mov    0x8(%ebp),%eax
80101024:	8b 40 04             	mov    0x4(%eax),%eax
80101027:	85 c0                	test   %eax,%eax
80101029:	7f 0d                	jg     80101038 <filedup+0x2d>
    panic("filedup");
8010102b:	83 ec 0c             	sub    $0xc,%esp
8010102e:	68 dd 85 10 80       	push   $0x801085dd
80101033:	e8 2f f5 ff ff       	call   80100567 <panic>
  f->ref++;
80101038:	8b 45 08             	mov    0x8(%ebp),%eax
8010103b:	8b 40 04             	mov    0x4(%eax),%eax
8010103e:	8d 50 01             	lea    0x1(%eax),%edx
80101041:	8b 45 08             	mov    0x8(%ebp),%eax
80101044:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101047:	83 ec 0c             	sub    $0xc,%esp
8010104a:	68 20 08 11 80       	push   $0x80110820
8010104f:	e8 57 40 00 00       	call   801050ab <release>
80101054:	83 c4 10             	add    $0x10,%esp
  return f;
80101057:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010105a:	c9                   	leave  
8010105b:	c3                   	ret    

8010105c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
8010105c:	55                   	push   %ebp
8010105d:	89 e5                	mov    %esp,%ebp
8010105f:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
80101062:	83 ec 0c             	sub    $0xc,%esp
80101065:	68 20 08 11 80       	push   $0x80110820
8010106a:	e8 d5 3f 00 00       	call   80105044 <acquire>
8010106f:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101072:	8b 45 08             	mov    0x8(%ebp),%eax
80101075:	8b 40 04             	mov    0x4(%eax),%eax
80101078:	85 c0                	test   %eax,%eax
8010107a:	7f 0d                	jg     80101089 <fileclose+0x2d>
    panic("fileclose");
8010107c:	83 ec 0c             	sub    $0xc,%esp
8010107f:	68 e5 85 10 80       	push   $0x801085e5
80101084:	e8 de f4 ff ff       	call   80100567 <panic>
  if(--f->ref > 0){
80101089:	8b 45 08             	mov    0x8(%ebp),%eax
8010108c:	8b 40 04             	mov    0x4(%eax),%eax
8010108f:	8d 50 ff             	lea    -0x1(%eax),%edx
80101092:	8b 45 08             	mov    0x8(%ebp),%eax
80101095:	89 50 04             	mov    %edx,0x4(%eax)
80101098:	8b 45 08             	mov    0x8(%ebp),%eax
8010109b:	8b 40 04             	mov    0x4(%eax),%eax
8010109e:	85 c0                	test   %eax,%eax
801010a0:	7e 15                	jle    801010b7 <fileclose+0x5b>
    release(&ftable.lock);
801010a2:	83 ec 0c             	sub    $0xc,%esp
801010a5:	68 20 08 11 80       	push   $0x80110820
801010aa:	e8 fc 3f 00 00       	call   801050ab <release>
801010af:	83 c4 10             	add    $0x10,%esp
801010b2:	e9 8b 00 00 00       	jmp    80101142 <fileclose+0xe6>
    return;
  }
  ff = *f;
801010b7:	8b 45 08             	mov    0x8(%ebp),%eax
801010ba:	8b 10                	mov    (%eax),%edx
801010bc:	89 55 e0             	mov    %edx,-0x20(%ebp)
801010bf:	8b 50 04             	mov    0x4(%eax),%edx
801010c2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801010c5:	8b 50 08             	mov    0x8(%eax),%edx
801010c8:	89 55 e8             	mov    %edx,-0x18(%ebp)
801010cb:	8b 50 0c             	mov    0xc(%eax),%edx
801010ce:	89 55 ec             	mov    %edx,-0x14(%ebp)
801010d1:	8b 50 10             	mov    0x10(%eax),%edx
801010d4:	89 55 f0             	mov    %edx,-0x10(%ebp)
801010d7:	8b 40 14             	mov    0x14(%eax),%eax
801010da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
801010dd:	8b 45 08             	mov    0x8(%ebp),%eax
801010e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
801010e7:	8b 45 08             	mov    0x8(%ebp),%eax
801010ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801010f0:	83 ec 0c             	sub    $0xc,%esp
801010f3:	68 20 08 11 80       	push   $0x80110820
801010f8:	e8 ae 3f 00 00       	call   801050ab <release>
801010fd:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
80101100:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101103:	83 f8 01             	cmp    $0x1,%eax
80101106:	75 19                	jne    80101121 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
80101108:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
8010110c:	0f be d0             	movsbl %al,%edx
8010110f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101112:	83 ec 08             	sub    $0x8,%esp
80101115:	52                   	push   %edx
80101116:	50                   	push   %eax
80101117:	e8 90 30 00 00       	call   801041ac <pipeclose>
8010111c:	83 c4 10             	add    $0x10,%esp
8010111f:	eb 21                	jmp    80101142 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
80101121:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101124:	83 f8 02             	cmp    $0x2,%eax
80101127:	75 19                	jne    80101142 <fileclose+0xe6>
    begin_op();
80101129:	e8 28 24 00 00       	call   80103556 <begin_op>
    iput(ff.ip);
8010112e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101131:	83 ec 0c             	sub    $0xc,%esp
80101134:	50                   	push   %eax
80101135:	e8 0b 0a 00 00       	call   80101b45 <iput>
8010113a:	83 c4 10             	add    $0x10,%esp
    end_op();
8010113d:	e8 a0 24 00 00       	call   801035e2 <end_op>
  }
}
80101142:	c9                   	leave  
80101143:	c3                   	ret    

80101144 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101144:	55                   	push   %ebp
80101145:	89 e5                	mov    %esp,%ebp
80101147:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
8010114a:	8b 45 08             	mov    0x8(%ebp),%eax
8010114d:	8b 00                	mov    (%eax),%eax
8010114f:	83 f8 02             	cmp    $0x2,%eax
80101152:	75 40                	jne    80101194 <filestat+0x50>
    ilock(f->ip);
80101154:	8b 45 08             	mov    0x8(%ebp),%eax
80101157:	8b 40 10             	mov    0x10(%eax),%eax
8010115a:	83 ec 0c             	sub    $0xc,%esp
8010115d:	50                   	push   %eax
8010115e:	e8 12 08 00 00       	call   80101975 <ilock>
80101163:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
80101166:	8b 45 08             	mov    0x8(%ebp),%eax
80101169:	8b 40 10             	mov    0x10(%eax),%eax
8010116c:	83 ec 08             	sub    $0x8,%esp
8010116f:	ff 75 0c             	pushl  0xc(%ebp)
80101172:	50                   	push   %eax
80101173:	e8 20 0d 00 00       	call   80101e98 <stati>
80101178:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
8010117b:	8b 45 08             	mov    0x8(%ebp),%eax
8010117e:	8b 40 10             	mov    0x10(%eax),%eax
80101181:	83 ec 0c             	sub    $0xc,%esp
80101184:	50                   	push   %eax
80101185:	e8 49 09 00 00       	call   80101ad3 <iunlock>
8010118a:	83 c4 10             	add    $0x10,%esp
    return 0;
8010118d:	b8 00 00 00 00       	mov    $0x0,%eax
80101192:	eb 05                	jmp    80101199 <filestat+0x55>
  }
  return -1;
80101194:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101199:	c9                   	leave  
8010119a:	c3                   	ret    

8010119b <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
8010119b:	55                   	push   %ebp
8010119c:	89 e5                	mov    %esp,%ebp
8010119e:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
801011a1:	8b 45 08             	mov    0x8(%ebp),%eax
801011a4:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801011a8:	84 c0                	test   %al,%al
801011aa:	75 0a                	jne    801011b6 <fileread+0x1b>
    return -1;
801011ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011b1:	e9 9b 00 00 00       	jmp    80101251 <fileread+0xb6>
  if(f->type == FD_PIPE)
801011b6:	8b 45 08             	mov    0x8(%ebp),%eax
801011b9:	8b 00                	mov    (%eax),%eax
801011bb:	83 f8 01             	cmp    $0x1,%eax
801011be:	75 1a                	jne    801011da <fileread+0x3f>
    return piperead(f->pipe, addr, n);
801011c0:	8b 45 08             	mov    0x8(%ebp),%eax
801011c3:	8b 40 0c             	mov    0xc(%eax),%eax
801011c6:	83 ec 04             	sub    $0x4,%esp
801011c9:	ff 75 10             	pushl  0x10(%ebp)
801011cc:	ff 75 0c             	pushl  0xc(%ebp)
801011cf:	50                   	push   %eax
801011d0:	e8 84 31 00 00       	call   80104359 <piperead>
801011d5:	83 c4 10             	add    $0x10,%esp
801011d8:	eb 77                	jmp    80101251 <fileread+0xb6>
  if(f->type == FD_INODE){
801011da:	8b 45 08             	mov    0x8(%ebp),%eax
801011dd:	8b 00                	mov    (%eax),%eax
801011df:	83 f8 02             	cmp    $0x2,%eax
801011e2:	75 60                	jne    80101244 <fileread+0xa9>
    ilock(f->ip);
801011e4:	8b 45 08             	mov    0x8(%ebp),%eax
801011e7:	8b 40 10             	mov    0x10(%eax),%eax
801011ea:	83 ec 0c             	sub    $0xc,%esp
801011ed:	50                   	push   %eax
801011ee:	e8 82 07 00 00       	call   80101975 <ilock>
801011f3:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801011f9:	8b 45 08             	mov    0x8(%ebp),%eax
801011fc:	8b 50 14             	mov    0x14(%eax),%edx
801011ff:	8b 45 08             	mov    0x8(%ebp),%eax
80101202:	8b 40 10             	mov    0x10(%eax),%eax
80101205:	51                   	push   %ecx
80101206:	52                   	push   %edx
80101207:	ff 75 0c             	pushl  0xc(%ebp)
8010120a:	50                   	push   %eax
8010120b:	e8 ce 0c 00 00       	call   80101ede <readi>
80101210:	83 c4 10             	add    $0x10,%esp
80101213:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101216:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010121a:	7e 11                	jle    8010122d <fileread+0x92>
      f->off += r;
8010121c:	8b 45 08             	mov    0x8(%ebp),%eax
8010121f:	8b 50 14             	mov    0x14(%eax),%edx
80101222:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101225:	01 c2                	add    %eax,%edx
80101227:	8b 45 08             	mov    0x8(%ebp),%eax
8010122a:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
8010122d:	8b 45 08             	mov    0x8(%ebp),%eax
80101230:	8b 40 10             	mov    0x10(%eax),%eax
80101233:	83 ec 0c             	sub    $0xc,%esp
80101236:	50                   	push   %eax
80101237:	e8 97 08 00 00       	call   80101ad3 <iunlock>
8010123c:	83 c4 10             	add    $0x10,%esp
    return r;
8010123f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101242:	eb 0d                	jmp    80101251 <fileread+0xb6>
  }
  panic("fileread");
80101244:	83 ec 0c             	sub    $0xc,%esp
80101247:	68 ef 85 10 80       	push   $0x801085ef
8010124c:	e8 16 f3 ff ff       	call   80100567 <panic>
}
80101251:	c9                   	leave  
80101252:	c3                   	ret    

80101253 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101253:	55                   	push   %ebp
80101254:	89 e5                	mov    %esp,%ebp
80101256:	53                   	push   %ebx
80101257:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
8010125a:	8b 45 08             	mov    0x8(%ebp),%eax
8010125d:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80101261:	84 c0                	test   %al,%al
80101263:	75 0a                	jne    8010126f <filewrite+0x1c>
    return -1;
80101265:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010126a:	e9 1b 01 00 00       	jmp    8010138a <filewrite+0x137>
  if(f->type == FD_PIPE)
8010126f:	8b 45 08             	mov    0x8(%ebp),%eax
80101272:	8b 00                	mov    (%eax),%eax
80101274:	83 f8 01             	cmp    $0x1,%eax
80101277:	75 1d                	jne    80101296 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
80101279:	8b 45 08             	mov    0x8(%ebp),%eax
8010127c:	8b 40 0c             	mov    0xc(%eax),%eax
8010127f:	83 ec 04             	sub    $0x4,%esp
80101282:	ff 75 10             	pushl  0x10(%ebp)
80101285:	ff 75 0c             	pushl  0xc(%ebp)
80101288:	50                   	push   %eax
80101289:	e8 c8 2f 00 00       	call   80104256 <pipewrite>
8010128e:	83 c4 10             	add    $0x10,%esp
80101291:	e9 f4 00 00 00       	jmp    8010138a <filewrite+0x137>
  if(f->type == FD_INODE){
80101296:	8b 45 08             	mov    0x8(%ebp),%eax
80101299:	8b 00                	mov    (%eax),%eax
8010129b:	83 f8 02             	cmp    $0x2,%eax
8010129e:	0f 85 d9 00 00 00    	jne    8010137d <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801012a4:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
801012ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801012b2:	e9 a3 00 00 00       	jmp    8010135a <filewrite+0x107>
      int n1 = n - i;
801012b7:	8b 45 10             	mov    0x10(%ebp),%eax
801012ba:	2b 45 f4             	sub    -0xc(%ebp),%eax
801012bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
801012c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012c3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801012c6:	7e 06                	jle    801012ce <filewrite+0x7b>
        n1 = max;
801012c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801012cb:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
801012ce:	e8 83 22 00 00       	call   80103556 <begin_op>
      ilock(f->ip);
801012d3:	8b 45 08             	mov    0x8(%ebp),%eax
801012d6:	8b 40 10             	mov    0x10(%eax),%eax
801012d9:	83 ec 0c             	sub    $0xc,%esp
801012dc:	50                   	push   %eax
801012dd:	e8 93 06 00 00       	call   80101975 <ilock>
801012e2:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801012e5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801012e8:	8b 45 08             	mov    0x8(%ebp),%eax
801012eb:	8b 50 14             	mov    0x14(%eax),%edx
801012ee:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801012f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801012f4:	01 c3                	add    %eax,%ebx
801012f6:	8b 45 08             	mov    0x8(%ebp),%eax
801012f9:	8b 40 10             	mov    0x10(%eax),%eax
801012fc:	51                   	push   %ecx
801012fd:	52                   	push   %edx
801012fe:	53                   	push   %ebx
801012ff:	50                   	push   %eax
80101300:	e8 30 0d 00 00       	call   80102035 <writei>
80101305:	83 c4 10             	add    $0x10,%esp
80101308:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010130b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010130f:	7e 11                	jle    80101322 <filewrite+0xcf>
        f->off += r;
80101311:	8b 45 08             	mov    0x8(%ebp),%eax
80101314:	8b 50 14             	mov    0x14(%eax),%edx
80101317:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010131a:	01 c2                	add    %eax,%edx
8010131c:	8b 45 08             	mov    0x8(%ebp),%eax
8010131f:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101322:	8b 45 08             	mov    0x8(%ebp),%eax
80101325:	8b 40 10             	mov    0x10(%eax),%eax
80101328:	83 ec 0c             	sub    $0xc,%esp
8010132b:	50                   	push   %eax
8010132c:	e8 a2 07 00 00       	call   80101ad3 <iunlock>
80101331:	83 c4 10             	add    $0x10,%esp
      end_op();
80101334:	e8 a9 22 00 00       	call   801035e2 <end_op>

      if(r < 0)
80101339:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010133d:	78 29                	js     80101368 <filewrite+0x115>
        break;
      if(r != n1)
8010133f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101342:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80101345:	74 0d                	je     80101354 <filewrite+0x101>
        panic("short filewrite");
80101347:	83 ec 0c             	sub    $0xc,%esp
8010134a:	68 f8 85 10 80       	push   $0x801085f8
8010134f:	e8 13 f2 ff ff       	call   80100567 <panic>
      i += r;
80101354:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101357:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
8010135a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010135d:	3b 45 10             	cmp    0x10(%ebp),%eax
80101360:	0f 8c 51 ff ff ff    	jl     801012b7 <filewrite+0x64>
80101366:	eb 01                	jmp    80101369 <filewrite+0x116>
        break;
80101368:	90                   	nop
    }
    return i == n ? n : -1;
80101369:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010136c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010136f:	75 05                	jne    80101376 <filewrite+0x123>
80101371:	8b 45 10             	mov    0x10(%ebp),%eax
80101374:	eb 14                	jmp    8010138a <filewrite+0x137>
80101376:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010137b:	eb 0d                	jmp    8010138a <filewrite+0x137>
  }
  panic("filewrite");
8010137d:	83 ec 0c             	sub    $0xc,%esp
80101380:	68 08 86 10 80       	push   $0x80108608
80101385:	e8 dd f1 ff ff       	call   80100567 <panic>
}
8010138a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010138d:	c9                   	leave  
8010138e:	c3                   	ret    

8010138f <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
8010138f:	55                   	push   %ebp
80101390:	89 e5                	mov    %esp,%ebp
80101392:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101395:	8b 45 08             	mov    0x8(%ebp),%eax
80101398:	83 ec 08             	sub    $0x8,%esp
8010139b:	6a 01                	push   $0x1
8010139d:	50                   	push   %eax
8010139e:	e8 13 ee ff ff       	call   801001b6 <bread>
801013a3:	83 c4 10             	add    $0x10,%esp
801013a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801013a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013ac:	83 c0 18             	add    $0x18,%eax
801013af:	83 ec 04             	sub    $0x4,%esp
801013b2:	6a 1c                	push   $0x1c
801013b4:	50                   	push   %eax
801013b5:	ff 75 0c             	pushl  0xc(%ebp)
801013b8:	e8 a9 3f 00 00       	call   80105366 <memmove>
801013bd:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801013c0:	83 ec 0c             	sub    $0xc,%esp
801013c3:	ff 75 f4             	pushl  -0xc(%ebp)
801013c6:	e8 63 ee ff ff       	call   8010022e <brelse>
801013cb:	83 c4 10             	add    $0x10,%esp
}
801013ce:	90                   	nop
801013cf:	c9                   	leave  
801013d0:	c3                   	ret    

801013d1 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
801013d1:	55                   	push   %ebp
801013d2:	89 e5                	mov    %esp,%ebp
801013d4:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
801013d7:	8b 55 0c             	mov    0xc(%ebp),%edx
801013da:	8b 45 08             	mov    0x8(%ebp),%eax
801013dd:	83 ec 08             	sub    $0x8,%esp
801013e0:	52                   	push   %edx
801013e1:	50                   	push   %eax
801013e2:	e8 cf ed ff ff       	call   801001b6 <bread>
801013e7:	83 c4 10             	add    $0x10,%esp
801013ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801013ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013f0:	83 c0 18             	add    $0x18,%eax
801013f3:	83 ec 04             	sub    $0x4,%esp
801013f6:	68 00 02 00 00       	push   $0x200
801013fb:	6a 00                	push   $0x0
801013fd:	50                   	push   %eax
801013fe:	e8 a4 3e 00 00       	call   801052a7 <memset>
80101403:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101406:	83 ec 0c             	sub    $0xc,%esp
80101409:	ff 75 f4             	pushl  -0xc(%ebp)
8010140c:	e8 7d 23 00 00       	call   8010378e <log_write>
80101411:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101414:	83 ec 0c             	sub    $0xc,%esp
80101417:	ff 75 f4             	pushl  -0xc(%ebp)
8010141a:	e8 0f ee ff ff       	call   8010022e <brelse>
8010141f:	83 c4 10             	add    $0x10,%esp
}
80101422:	90                   	nop
80101423:	c9                   	leave  
80101424:	c3                   	ret    

80101425 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101425:	55                   	push   %ebp
80101426:	89 e5                	mov    %esp,%ebp
80101428:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
8010142b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101432:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101439:	e9 13 01 00 00       	jmp    80101551 <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
8010143e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101441:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101447:	85 c0                	test   %eax,%eax
80101449:	0f 48 c2             	cmovs  %edx,%eax
8010144c:	c1 f8 0c             	sar    $0xc,%eax
8010144f:	89 c2                	mov    %eax,%edx
80101451:	a1 38 12 11 80       	mov    0x80111238,%eax
80101456:	01 d0                	add    %edx,%eax
80101458:	83 ec 08             	sub    $0x8,%esp
8010145b:	50                   	push   %eax
8010145c:	ff 75 08             	pushl  0x8(%ebp)
8010145f:	e8 52 ed ff ff       	call   801001b6 <bread>
80101464:	83 c4 10             	add    $0x10,%esp
80101467:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010146a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101471:	e9 a6 00 00 00       	jmp    8010151c <balloc+0xf7>
      m = 1 << (bi % 8);
80101476:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101479:	99                   	cltd   
8010147a:	c1 ea 1d             	shr    $0x1d,%edx
8010147d:	01 d0                	add    %edx,%eax
8010147f:	83 e0 07             	and    $0x7,%eax
80101482:	29 d0                	sub    %edx,%eax
80101484:	ba 01 00 00 00       	mov    $0x1,%edx
80101489:	89 c1                	mov    %eax,%ecx
8010148b:	d3 e2                	shl    %cl,%edx
8010148d:	89 d0                	mov    %edx,%eax
8010148f:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101492:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101495:	8d 50 07             	lea    0x7(%eax),%edx
80101498:	85 c0                	test   %eax,%eax
8010149a:	0f 48 c2             	cmovs  %edx,%eax
8010149d:	c1 f8 03             	sar    $0x3,%eax
801014a0:	89 c2                	mov    %eax,%edx
801014a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014a5:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801014aa:	0f b6 c0             	movzbl %al,%eax
801014ad:	23 45 e8             	and    -0x18(%ebp),%eax
801014b0:	85 c0                	test   %eax,%eax
801014b2:	75 64                	jne    80101518 <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
801014b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014b7:	8d 50 07             	lea    0x7(%eax),%edx
801014ba:	85 c0                	test   %eax,%eax
801014bc:	0f 48 c2             	cmovs  %edx,%eax
801014bf:	c1 f8 03             	sar    $0x3,%eax
801014c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014c5:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801014ca:	89 d1                	mov    %edx,%ecx
801014cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014cf:	09 ca                	or     %ecx,%edx
801014d1:	89 d1                	mov    %edx,%ecx
801014d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014d6:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
801014da:	83 ec 0c             	sub    $0xc,%esp
801014dd:	ff 75 ec             	pushl  -0x14(%ebp)
801014e0:	e8 a9 22 00 00       	call   8010378e <log_write>
801014e5:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
801014e8:	83 ec 0c             	sub    $0xc,%esp
801014eb:	ff 75 ec             	pushl  -0x14(%ebp)
801014ee:	e8 3b ed ff ff       	call   8010022e <brelse>
801014f3:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
801014f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014fc:	01 c2                	add    %eax,%edx
801014fe:	8b 45 08             	mov    0x8(%ebp),%eax
80101501:	83 ec 08             	sub    $0x8,%esp
80101504:	52                   	push   %edx
80101505:	50                   	push   %eax
80101506:	e8 c6 fe ff ff       	call   801013d1 <bzero>
8010150b:	83 c4 10             	add    $0x10,%esp
        return b + bi;
8010150e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101511:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101514:	01 d0                	add    %edx,%eax
80101516:	eb 57                	jmp    8010156f <balloc+0x14a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101518:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010151c:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101523:	7f 17                	jg     8010153c <balloc+0x117>
80101525:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101528:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010152b:	01 d0                	add    %edx,%eax
8010152d:	89 c2                	mov    %eax,%edx
8010152f:	a1 20 12 11 80       	mov    0x80111220,%eax
80101534:	39 c2                	cmp    %eax,%edx
80101536:	0f 82 3a ff ff ff    	jb     80101476 <balloc+0x51>
      }
    }
    brelse(bp);
8010153c:	83 ec 0c             	sub    $0xc,%esp
8010153f:	ff 75 ec             	pushl  -0x14(%ebp)
80101542:	e8 e7 ec ff ff       	call   8010022e <brelse>
80101547:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
8010154a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101551:	8b 15 20 12 11 80    	mov    0x80111220,%edx
80101557:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010155a:	39 c2                	cmp    %eax,%edx
8010155c:	0f 87 dc fe ff ff    	ja     8010143e <balloc+0x19>
  }
  panic("balloc: out of blocks");
80101562:	83 ec 0c             	sub    $0xc,%esp
80101565:	68 14 86 10 80       	push   $0x80108614
8010156a:	e8 f8 ef ff ff       	call   80100567 <panic>
}
8010156f:	c9                   	leave  
80101570:	c3                   	ret    

80101571 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101571:	55                   	push   %ebp
80101572:	89 e5                	mov    %esp,%ebp
80101574:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101577:	83 ec 08             	sub    $0x8,%esp
8010157a:	68 20 12 11 80       	push   $0x80111220
8010157f:	ff 75 08             	pushl  0x8(%ebp)
80101582:	e8 08 fe ff ff       	call   8010138f <readsb>
80101587:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
8010158a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010158d:	c1 e8 0c             	shr    $0xc,%eax
80101590:	89 c2                	mov    %eax,%edx
80101592:	a1 38 12 11 80       	mov    0x80111238,%eax
80101597:	01 c2                	add    %eax,%edx
80101599:	8b 45 08             	mov    0x8(%ebp),%eax
8010159c:	83 ec 08             	sub    $0x8,%esp
8010159f:	52                   	push   %edx
801015a0:	50                   	push   %eax
801015a1:	e8 10 ec ff ff       	call   801001b6 <bread>
801015a6:	83 c4 10             	add    $0x10,%esp
801015a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801015ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801015af:	25 ff 0f 00 00       	and    $0xfff,%eax
801015b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801015b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015ba:	99                   	cltd   
801015bb:	c1 ea 1d             	shr    $0x1d,%edx
801015be:	01 d0                	add    %edx,%eax
801015c0:	83 e0 07             	and    $0x7,%eax
801015c3:	29 d0                	sub    %edx,%eax
801015c5:	ba 01 00 00 00       	mov    $0x1,%edx
801015ca:	89 c1                	mov    %eax,%ecx
801015cc:	d3 e2                	shl    %cl,%edx
801015ce:	89 d0                	mov    %edx,%eax
801015d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
801015d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015d6:	8d 50 07             	lea    0x7(%eax),%edx
801015d9:	85 c0                	test   %eax,%eax
801015db:	0f 48 c2             	cmovs  %edx,%eax
801015de:	c1 f8 03             	sar    $0x3,%eax
801015e1:	89 c2                	mov    %eax,%edx
801015e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015e6:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801015eb:	0f b6 c0             	movzbl %al,%eax
801015ee:	23 45 ec             	and    -0x14(%ebp),%eax
801015f1:	85 c0                	test   %eax,%eax
801015f3:	75 0d                	jne    80101602 <bfree+0x91>
    panic("freeing free block");
801015f5:	83 ec 0c             	sub    $0xc,%esp
801015f8:	68 2a 86 10 80       	push   $0x8010862a
801015fd:	e8 65 ef ff ff       	call   80100567 <panic>
  bp->data[bi/8] &= ~m;
80101602:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101605:	8d 50 07             	lea    0x7(%eax),%edx
80101608:	85 c0                	test   %eax,%eax
8010160a:	0f 48 c2             	cmovs  %edx,%eax
8010160d:	c1 f8 03             	sar    $0x3,%eax
80101610:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101613:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101618:	89 d1                	mov    %edx,%ecx
8010161a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010161d:	f7 d2                	not    %edx
8010161f:	21 ca                	and    %ecx,%edx
80101621:	89 d1                	mov    %edx,%ecx
80101623:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101626:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
8010162a:	83 ec 0c             	sub    $0xc,%esp
8010162d:	ff 75 f4             	pushl  -0xc(%ebp)
80101630:	e8 59 21 00 00       	call   8010378e <log_write>
80101635:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101638:	83 ec 0c             	sub    $0xc,%esp
8010163b:	ff 75 f4             	pushl  -0xc(%ebp)
8010163e:	e8 eb eb ff ff       	call   8010022e <brelse>
80101643:	83 c4 10             	add    $0x10,%esp
}
80101646:	90                   	nop
80101647:	c9                   	leave  
80101648:	c3                   	ret    

80101649 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101649:	55                   	push   %ebp
8010164a:	89 e5                	mov    %esp,%ebp
8010164c:	57                   	push   %edi
8010164d:	56                   	push   %esi
8010164e:	53                   	push   %ebx
8010164f:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
80101652:	83 ec 08             	sub    $0x8,%esp
80101655:	68 3d 86 10 80       	push   $0x8010863d
8010165a:	68 40 12 11 80       	push   $0x80111240
8010165f:	e8 be 39 00 00       	call   80105022 <initlock>
80101664:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80101667:	83 ec 08             	sub    $0x8,%esp
8010166a:	68 20 12 11 80       	push   $0x80111220
8010166f:	ff 75 08             	pushl  0x8(%ebp)
80101672:	e8 18 fd ff ff       	call   8010138f <readsb>
80101677:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
8010167a:	a1 38 12 11 80       	mov    0x80111238,%eax
8010167f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101682:	8b 3d 34 12 11 80    	mov    0x80111234,%edi
80101688:	8b 35 30 12 11 80    	mov    0x80111230,%esi
8010168e:	8b 1d 2c 12 11 80    	mov    0x8011122c,%ebx
80101694:	8b 0d 28 12 11 80    	mov    0x80111228,%ecx
8010169a:	8b 15 24 12 11 80    	mov    0x80111224,%edx
801016a0:	a1 20 12 11 80       	mov    0x80111220,%eax
801016a5:	ff 75 e4             	pushl  -0x1c(%ebp)
801016a8:	57                   	push   %edi
801016a9:	56                   	push   %esi
801016aa:	53                   	push   %ebx
801016ab:	51                   	push   %ecx
801016ac:	52                   	push   %edx
801016ad:	50                   	push   %eax
801016ae:	68 44 86 10 80       	push   $0x80108644
801016b3:	e8 0c ed ff ff       	call   801003c4 <cprintf>
801016b8:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
801016bb:	90                   	nop
801016bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016bf:	5b                   	pop    %ebx
801016c0:	5e                   	pop    %esi
801016c1:	5f                   	pop    %edi
801016c2:	5d                   	pop    %ebp
801016c3:	c3                   	ret    

801016c4 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801016c4:	55                   	push   %ebp
801016c5:	89 e5                	mov    %esp,%ebp
801016c7:	83 ec 28             	sub    $0x28,%esp
801016ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801016cd:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801016d1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801016d8:	e9 9e 00 00 00       	jmp    8010177b <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
801016dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016e0:	c1 e8 03             	shr    $0x3,%eax
801016e3:	89 c2                	mov    %eax,%edx
801016e5:	a1 34 12 11 80       	mov    0x80111234,%eax
801016ea:	01 d0                	add    %edx,%eax
801016ec:	83 ec 08             	sub    $0x8,%esp
801016ef:	50                   	push   %eax
801016f0:	ff 75 08             	pushl  0x8(%ebp)
801016f3:	e8 be ea ff ff       	call   801001b6 <bread>
801016f8:	83 c4 10             	add    $0x10,%esp
801016fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801016fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101701:	8d 50 18             	lea    0x18(%eax),%edx
80101704:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101707:	83 e0 07             	and    $0x7,%eax
8010170a:	c1 e0 06             	shl    $0x6,%eax
8010170d:	01 d0                	add    %edx,%eax
8010170f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101712:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101715:	0f b7 00             	movzwl (%eax),%eax
80101718:	66 85 c0             	test   %ax,%ax
8010171b:	75 4c                	jne    80101769 <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
8010171d:	83 ec 04             	sub    $0x4,%esp
80101720:	6a 40                	push   $0x40
80101722:	6a 00                	push   $0x0
80101724:	ff 75 ec             	pushl  -0x14(%ebp)
80101727:	e8 7b 3b 00 00       	call   801052a7 <memset>
8010172c:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
8010172f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101732:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
80101736:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101739:	83 ec 0c             	sub    $0xc,%esp
8010173c:	ff 75 f0             	pushl  -0x10(%ebp)
8010173f:	e8 4a 20 00 00       	call   8010378e <log_write>
80101744:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	ff 75 f0             	pushl  -0x10(%ebp)
8010174d:	e8 dc ea ff ff       	call   8010022e <brelse>
80101752:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
80101755:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101758:	83 ec 08             	sub    $0x8,%esp
8010175b:	50                   	push   %eax
8010175c:	ff 75 08             	pushl  0x8(%ebp)
8010175f:	e8 f8 00 00 00       	call   8010185c <iget>
80101764:	83 c4 10             	add    $0x10,%esp
80101767:	eb 30                	jmp    80101799 <ialloc+0xd5>
    }
    brelse(bp);
80101769:	83 ec 0c             	sub    $0xc,%esp
8010176c:	ff 75 f0             	pushl  -0x10(%ebp)
8010176f:	e8 ba ea ff ff       	call   8010022e <brelse>
80101774:	83 c4 10             	add    $0x10,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101777:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010177b:	8b 15 28 12 11 80    	mov    0x80111228,%edx
80101781:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101784:	39 c2                	cmp    %eax,%edx
80101786:	0f 87 51 ff ff ff    	ja     801016dd <ialloc+0x19>
  }
  panic("ialloc: no inodes");
8010178c:	83 ec 0c             	sub    $0xc,%esp
8010178f:	68 97 86 10 80       	push   $0x80108697
80101794:	e8 ce ed ff ff       	call   80100567 <panic>
}
80101799:	c9                   	leave  
8010179a:	c3                   	ret    

8010179b <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
8010179b:	55                   	push   %ebp
8010179c:	89 e5                	mov    %esp,%ebp
8010179e:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017a1:	8b 45 08             	mov    0x8(%ebp),%eax
801017a4:	8b 40 04             	mov    0x4(%eax),%eax
801017a7:	c1 e8 03             	shr    $0x3,%eax
801017aa:	89 c2                	mov    %eax,%edx
801017ac:	a1 34 12 11 80       	mov    0x80111234,%eax
801017b1:	01 c2                	add    %eax,%edx
801017b3:	8b 45 08             	mov    0x8(%ebp),%eax
801017b6:	8b 00                	mov    (%eax),%eax
801017b8:	83 ec 08             	sub    $0x8,%esp
801017bb:	52                   	push   %edx
801017bc:	50                   	push   %eax
801017bd:	e8 f4 e9 ff ff       	call   801001b6 <bread>
801017c2:	83 c4 10             	add    $0x10,%esp
801017c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017cb:	8d 50 18             	lea    0x18(%eax),%edx
801017ce:	8b 45 08             	mov    0x8(%ebp),%eax
801017d1:	8b 40 04             	mov    0x4(%eax),%eax
801017d4:	83 e0 07             	and    $0x7,%eax
801017d7:	c1 e0 06             	shl    $0x6,%eax
801017da:	01 d0                	add    %edx,%eax
801017dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801017df:	8b 45 08             	mov    0x8(%ebp),%eax
801017e2:	0f b7 50 10          	movzwl 0x10(%eax),%edx
801017e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017e9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801017ec:	8b 45 08             	mov    0x8(%ebp),%eax
801017ef:	0f b7 50 12          	movzwl 0x12(%eax),%edx
801017f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017f6:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801017fa:	8b 45 08             	mov    0x8(%ebp),%eax
801017fd:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101801:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101804:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101808:	8b 45 08             	mov    0x8(%ebp),%eax
8010180b:	0f b7 50 16          	movzwl 0x16(%eax),%edx
8010180f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101812:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101816:	8b 45 08             	mov    0x8(%ebp),%eax
80101819:	8b 50 18             	mov    0x18(%eax),%edx
8010181c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010181f:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101822:	8b 45 08             	mov    0x8(%ebp),%eax
80101825:	8d 50 1c             	lea    0x1c(%eax),%edx
80101828:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010182b:	83 c0 0c             	add    $0xc,%eax
8010182e:	83 ec 04             	sub    $0x4,%esp
80101831:	6a 34                	push   $0x34
80101833:	52                   	push   %edx
80101834:	50                   	push   %eax
80101835:	e8 2c 3b 00 00       	call   80105366 <memmove>
8010183a:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010183d:	83 ec 0c             	sub    $0xc,%esp
80101840:	ff 75 f4             	pushl  -0xc(%ebp)
80101843:	e8 46 1f 00 00       	call   8010378e <log_write>
80101848:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010184b:	83 ec 0c             	sub    $0xc,%esp
8010184e:	ff 75 f4             	pushl  -0xc(%ebp)
80101851:	e8 d8 e9 ff ff       	call   8010022e <brelse>
80101856:	83 c4 10             	add    $0x10,%esp
}
80101859:	90                   	nop
8010185a:	c9                   	leave  
8010185b:	c3                   	ret    

8010185c <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010185c:	55                   	push   %ebp
8010185d:	89 e5                	mov    %esp,%ebp
8010185f:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101862:	83 ec 0c             	sub    $0xc,%esp
80101865:	68 40 12 11 80       	push   $0x80111240
8010186a:	e8 d5 37 00 00       	call   80105044 <acquire>
8010186f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101872:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101879:	c7 45 f4 74 12 11 80 	movl   $0x80111274,-0xc(%ebp)
80101880:	eb 5d                	jmp    801018df <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101882:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101885:	8b 40 08             	mov    0x8(%eax),%eax
80101888:	85 c0                	test   %eax,%eax
8010188a:	7e 39                	jle    801018c5 <iget+0x69>
8010188c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010188f:	8b 00                	mov    (%eax),%eax
80101891:	39 45 08             	cmp    %eax,0x8(%ebp)
80101894:	75 2f                	jne    801018c5 <iget+0x69>
80101896:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101899:	8b 40 04             	mov    0x4(%eax),%eax
8010189c:	39 45 0c             	cmp    %eax,0xc(%ebp)
8010189f:	75 24                	jne    801018c5 <iget+0x69>
      ip->ref++;
801018a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018a4:	8b 40 08             	mov    0x8(%eax),%eax
801018a7:	8d 50 01             	lea    0x1(%eax),%edx
801018aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ad:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801018b0:	83 ec 0c             	sub    $0xc,%esp
801018b3:	68 40 12 11 80       	push   $0x80111240
801018b8:	e8 ee 37 00 00       	call   801050ab <release>
801018bd:	83 c4 10             	add    $0x10,%esp
      return ip;
801018c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018c3:	eb 74                	jmp    80101939 <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801018c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018c9:	75 10                	jne    801018db <iget+0x7f>
801018cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ce:	8b 40 08             	mov    0x8(%eax),%eax
801018d1:	85 c0                	test   %eax,%eax
801018d3:	75 06                	jne    801018db <iget+0x7f>
      empty = ip;
801018d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018db:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
801018df:	81 7d f4 14 22 11 80 	cmpl   $0x80112214,-0xc(%ebp)
801018e6:	72 9a                	jb     80101882 <iget+0x26>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801018e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018ec:	75 0d                	jne    801018fb <iget+0x9f>
    panic("iget: no inodes");
801018ee:	83 ec 0c             	sub    $0xc,%esp
801018f1:	68 a9 86 10 80       	push   $0x801086a9
801018f6:	e8 6c ec ff ff       	call   80100567 <panic>

  ip = empty;
801018fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101901:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101904:	8b 55 08             	mov    0x8(%ebp),%edx
80101907:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101909:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010190c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010190f:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101912:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101915:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
8010191c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010191f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101926:	83 ec 0c             	sub    $0xc,%esp
80101929:	68 40 12 11 80       	push   $0x80111240
8010192e:	e8 78 37 00 00       	call   801050ab <release>
80101933:	83 c4 10             	add    $0x10,%esp

  return ip;
80101936:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101939:	c9                   	leave  
8010193a:	c3                   	ret    

8010193b <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
8010193b:	55                   	push   %ebp
8010193c:	89 e5                	mov    %esp,%ebp
8010193e:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101941:	83 ec 0c             	sub    $0xc,%esp
80101944:	68 40 12 11 80       	push   $0x80111240
80101949:	e8 f6 36 00 00       	call   80105044 <acquire>
8010194e:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101951:	8b 45 08             	mov    0x8(%ebp),%eax
80101954:	8b 40 08             	mov    0x8(%eax),%eax
80101957:	8d 50 01             	lea    0x1(%eax),%edx
8010195a:	8b 45 08             	mov    0x8(%ebp),%eax
8010195d:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101960:	83 ec 0c             	sub    $0xc,%esp
80101963:	68 40 12 11 80       	push   $0x80111240
80101968:	e8 3e 37 00 00       	call   801050ab <release>
8010196d:	83 c4 10             	add    $0x10,%esp
  return ip;
80101970:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101973:	c9                   	leave  
80101974:	c3                   	ret    

80101975 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101975:	55                   	push   %ebp
80101976:	89 e5                	mov    %esp,%ebp
80101978:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
8010197b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010197f:	74 0a                	je     8010198b <ilock+0x16>
80101981:	8b 45 08             	mov    0x8(%ebp),%eax
80101984:	8b 40 08             	mov    0x8(%eax),%eax
80101987:	85 c0                	test   %eax,%eax
80101989:	7f 0d                	jg     80101998 <ilock+0x23>
    panic("ilock");
8010198b:	83 ec 0c             	sub    $0xc,%esp
8010198e:	68 b9 86 10 80       	push   $0x801086b9
80101993:	e8 cf eb ff ff       	call   80100567 <panic>

  acquire(&icache.lock);
80101998:	83 ec 0c             	sub    $0xc,%esp
8010199b:	68 40 12 11 80       	push   $0x80111240
801019a0:	e8 9f 36 00 00       	call   80105044 <acquire>
801019a5:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
801019a8:	eb 13                	jmp    801019bd <ilock+0x48>
    sleep(ip, &icache.lock);
801019aa:	83 ec 08             	sub    $0x8,%esp
801019ad:	68 40 12 11 80       	push   $0x80111240
801019b2:	ff 75 08             	pushl  0x8(%ebp)
801019b5:	e8 91 33 00 00       	call   80104d4b <sleep>
801019ba:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
801019bd:	8b 45 08             	mov    0x8(%ebp),%eax
801019c0:	8b 40 0c             	mov    0xc(%eax),%eax
801019c3:	83 e0 01             	and    $0x1,%eax
801019c6:	85 c0                	test   %eax,%eax
801019c8:	75 e0                	jne    801019aa <ilock+0x35>
  ip->flags |= I_BUSY;
801019ca:	8b 45 08             	mov    0x8(%ebp),%eax
801019cd:	8b 40 0c             	mov    0xc(%eax),%eax
801019d0:	83 c8 01             	or     $0x1,%eax
801019d3:	89 c2                	mov    %eax,%edx
801019d5:	8b 45 08             	mov    0x8(%ebp),%eax
801019d8:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801019db:	83 ec 0c             	sub    $0xc,%esp
801019de:	68 40 12 11 80       	push   $0x80111240
801019e3:	e8 c3 36 00 00       	call   801050ab <release>
801019e8:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
801019eb:	8b 45 08             	mov    0x8(%ebp),%eax
801019ee:	8b 40 0c             	mov    0xc(%eax),%eax
801019f1:	83 e0 02             	and    $0x2,%eax
801019f4:	85 c0                	test   %eax,%eax
801019f6:	0f 85 d4 00 00 00    	jne    80101ad0 <ilock+0x15b>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019fc:	8b 45 08             	mov    0x8(%ebp),%eax
801019ff:	8b 40 04             	mov    0x4(%eax),%eax
80101a02:	c1 e8 03             	shr    $0x3,%eax
80101a05:	89 c2                	mov    %eax,%edx
80101a07:	a1 34 12 11 80       	mov    0x80111234,%eax
80101a0c:	01 c2                	add    %eax,%edx
80101a0e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a11:	8b 00                	mov    (%eax),%eax
80101a13:	83 ec 08             	sub    $0x8,%esp
80101a16:	52                   	push   %edx
80101a17:	50                   	push   %eax
80101a18:	e8 99 e7 ff ff       	call   801001b6 <bread>
80101a1d:	83 c4 10             	add    $0x10,%esp
80101a20:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a26:	8d 50 18             	lea    0x18(%eax),%edx
80101a29:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2c:	8b 40 04             	mov    0x4(%eax),%eax
80101a2f:	83 e0 07             	and    $0x7,%eax
80101a32:	c1 e0 06             	shl    $0x6,%eax
80101a35:	01 d0                	add    %edx,%eax
80101a37:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101a3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a3d:	0f b7 10             	movzwl (%eax),%edx
80101a40:	8b 45 08             	mov    0x8(%ebp),%eax
80101a43:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a4a:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101a4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a51:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101a55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a58:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101a5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5f:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a66:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101a6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6d:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a74:	8b 50 08             	mov    0x8(%eax),%edx
80101a77:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7a:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a80:	8d 50 0c             	lea    0xc(%eax),%edx
80101a83:	8b 45 08             	mov    0x8(%ebp),%eax
80101a86:	83 c0 1c             	add    $0x1c,%eax
80101a89:	83 ec 04             	sub    $0x4,%esp
80101a8c:	6a 34                	push   $0x34
80101a8e:	52                   	push   %edx
80101a8f:	50                   	push   %eax
80101a90:	e8 d1 38 00 00       	call   80105366 <memmove>
80101a95:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101a98:	83 ec 0c             	sub    $0xc,%esp
80101a9b:	ff 75 f4             	pushl  -0xc(%ebp)
80101a9e:	e8 8b e7 ff ff       	call   8010022e <brelse>
80101aa3:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101aa6:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa9:	8b 40 0c             	mov    0xc(%eax),%eax
80101aac:	83 c8 02             	or     $0x2,%eax
80101aaf:	89 c2                	mov    %eax,%edx
80101ab1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab4:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101ab7:	8b 45 08             	mov    0x8(%ebp),%eax
80101aba:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101abe:	66 85 c0             	test   %ax,%ax
80101ac1:	75 0d                	jne    80101ad0 <ilock+0x15b>
      panic("ilock: no type");
80101ac3:	83 ec 0c             	sub    $0xc,%esp
80101ac6:	68 bf 86 10 80       	push   $0x801086bf
80101acb:	e8 97 ea ff ff       	call   80100567 <panic>
  }
}
80101ad0:	90                   	nop
80101ad1:	c9                   	leave  
80101ad2:	c3                   	ret    

80101ad3 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101ad3:	55                   	push   %ebp
80101ad4:	89 e5                	mov    %esp,%ebp
80101ad6:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101ad9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101add:	74 17                	je     80101af6 <iunlock+0x23>
80101adf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae2:	8b 40 0c             	mov    0xc(%eax),%eax
80101ae5:	83 e0 01             	and    $0x1,%eax
80101ae8:	85 c0                	test   %eax,%eax
80101aea:	74 0a                	je     80101af6 <iunlock+0x23>
80101aec:	8b 45 08             	mov    0x8(%ebp),%eax
80101aef:	8b 40 08             	mov    0x8(%eax),%eax
80101af2:	85 c0                	test   %eax,%eax
80101af4:	7f 0d                	jg     80101b03 <iunlock+0x30>
    panic("iunlock");
80101af6:	83 ec 0c             	sub    $0xc,%esp
80101af9:	68 ce 86 10 80       	push   $0x801086ce
80101afe:	e8 64 ea ff ff       	call   80100567 <panic>

  acquire(&icache.lock);
80101b03:	83 ec 0c             	sub    $0xc,%esp
80101b06:	68 40 12 11 80       	push   $0x80111240
80101b0b:	e8 34 35 00 00       	call   80105044 <acquire>
80101b10:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101b13:	8b 45 08             	mov    0x8(%ebp),%eax
80101b16:	8b 40 0c             	mov    0xc(%eax),%eax
80101b19:	83 e0 fe             	and    $0xfffffffe,%eax
80101b1c:	89 c2                	mov    %eax,%edx
80101b1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b21:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101b24:	83 ec 0c             	sub    $0xc,%esp
80101b27:	ff 75 08             	pushl  0x8(%ebp)
80101b2a:	e8 07 33 00 00       	call   80104e36 <wakeup>
80101b2f:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101b32:	83 ec 0c             	sub    $0xc,%esp
80101b35:	68 40 12 11 80       	push   $0x80111240
80101b3a:	e8 6c 35 00 00       	call   801050ab <release>
80101b3f:	83 c4 10             	add    $0x10,%esp
}
80101b42:	90                   	nop
80101b43:	c9                   	leave  
80101b44:	c3                   	ret    

80101b45 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b45:	55                   	push   %ebp
80101b46:	89 e5                	mov    %esp,%ebp
80101b48:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101b4b:	83 ec 0c             	sub    $0xc,%esp
80101b4e:	68 40 12 11 80       	push   $0x80111240
80101b53:	e8 ec 34 00 00       	call   80105044 <acquire>
80101b58:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101b5b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5e:	8b 40 08             	mov    0x8(%eax),%eax
80101b61:	83 f8 01             	cmp    $0x1,%eax
80101b64:	0f 85 a9 00 00 00    	jne    80101c13 <iput+0xce>
80101b6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6d:	8b 40 0c             	mov    0xc(%eax),%eax
80101b70:	83 e0 02             	and    $0x2,%eax
80101b73:	85 c0                	test   %eax,%eax
80101b75:	0f 84 98 00 00 00    	je     80101c13 <iput+0xce>
80101b7b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101b82:	66 85 c0             	test   %ax,%ax
80101b85:	0f 85 88 00 00 00    	jne    80101c13 <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101b8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8e:	8b 40 0c             	mov    0xc(%eax),%eax
80101b91:	83 e0 01             	and    $0x1,%eax
80101b94:	85 c0                	test   %eax,%eax
80101b96:	74 0d                	je     80101ba5 <iput+0x60>
      panic("iput busy");
80101b98:	83 ec 0c             	sub    $0xc,%esp
80101b9b:	68 d6 86 10 80       	push   $0x801086d6
80101ba0:	e8 c2 e9 ff ff       	call   80100567 <panic>
    ip->flags |= I_BUSY;
80101ba5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba8:	8b 40 0c             	mov    0xc(%eax),%eax
80101bab:	83 c8 01             	or     $0x1,%eax
80101bae:	89 c2                	mov    %eax,%edx
80101bb0:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb3:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101bb6:	83 ec 0c             	sub    $0xc,%esp
80101bb9:	68 40 12 11 80       	push   $0x80111240
80101bbe:	e8 e8 34 00 00       	call   801050ab <release>
80101bc3:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101bc6:	83 ec 0c             	sub    $0xc,%esp
80101bc9:	ff 75 08             	pushl  0x8(%ebp)
80101bcc:	e8 a3 01 00 00       	call   80101d74 <itrunc>
80101bd1:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101bd4:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd7:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101bdd:	83 ec 0c             	sub    $0xc,%esp
80101be0:	ff 75 08             	pushl  0x8(%ebp)
80101be3:	e8 b3 fb ff ff       	call   8010179b <iupdate>
80101be8:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101beb:	83 ec 0c             	sub    $0xc,%esp
80101bee:	68 40 12 11 80       	push   $0x80111240
80101bf3:	e8 4c 34 00 00       	call   80105044 <acquire>
80101bf8:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101bfb:	8b 45 08             	mov    0x8(%ebp),%eax
80101bfe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101c05:	83 ec 0c             	sub    $0xc,%esp
80101c08:	ff 75 08             	pushl  0x8(%ebp)
80101c0b:	e8 26 32 00 00       	call   80104e36 <wakeup>
80101c10:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101c13:	8b 45 08             	mov    0x8(%ebp),%eax
80101c16:	8b 40 08             	mov    0x8(%eax),%eax
80101c19:	8d 50 ff             	lea    -0x1(%eax),%edx
80101c1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1f:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101c22:	83 ec 0c             	sub    $0xc,%esp
80101c25:	68 40 12 11 80       	push   $0x80111240
80101c2a:	e8 7c 34 00 00       	call   801050ab <release>
80101c2f:	83 c4 10             	add    $0x10,%esp
}
80101c32:	90                   	nop
80101c33:	c9                   	leave  
80101c34:	c3                   	ret    

80101c35 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101c35:	55                   	push   %ebp
80101c36:	89 e5                	mov    %esp,%ebp
80101c38:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101c3b:	83 ec 0c             	sub    $0xc,%esp
80101c3e:	ff 75 08             	pushl  0x8(%ebp)
80101c41:	e8 8d fe ff ff       	call   80101ad3 <iunlock>
80101c46:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101c49:	83 ec 0c             	sub    $0xc,%esp
80101c4c:	ff 75 08             	pushl  0x8(%ebp)
80101c4f:	e8 f1 fe ff ff       	call   80101b45 <iput>
80101c54:	83 c4 10             	add    $0x10,%esp
}
80101c57:	90                   	nop
80101c58:	c9                   	leave  
80101c59:	c3                   	ret    

80101c5a <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c5a:	55                   	push   %ebp
80101c5b:	89 e5                	mov    %esp,%ebp
80101c5d:	83 ec 18             	sub    $0x18,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c60:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101c64:	77 42                	ja     80101ca8 <bmap+0x4e>
    if((addr = ip->addrs[bn]) == 0)
80101c66:	8b 45 08             	mov    0x8(%ebp),%eax
80101c69:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c6c:	83 c2 04             	add    $0x4,%edx
80101c6f:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c73:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c7a:	75 24                	jne    80101ca0 <bmap+0x46>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c7f:	8b 00                	mov    (%eax),%eax
80101c81:	83 ec 0c             	sub    $0xc,%esp
80101c84:	50                   	push   %eax
80101c85:	e8 9b f7 ff ff       	call   80101425 <balloc>
80101c8a:	83 c4 10             	add    $0x10,%esp
80101c8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c90:	8b 45 08             	mov    0x8(%ebp),%eax
80101c93:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c96:	8d 4a 04             	lea    0x4(%edx),%ecx
80101c99:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c9c:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ca3:	e9 ca 00 00 00       	jmp    80101d72 <bmap+0x118>
  }
  bn -= NDIRECT;
80101ca8:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101cac:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101cb0:	0f 87 af 00 00 00    	ja     80101d65 <bmap+0x10b>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101cb6:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb9:	8b 40 4c             	mov    0x4c(%eax),%eax
80101cbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cc3:	75 1d                	jne    80101ce2 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101cc5:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc8:	8b 00                	mov    (%eax),%eax
80101cca:	83 ec 0c             	sub    $0xc,%esp
80101ccd:	50                   	push   %eax
80101cce:	e8 52 f7 ff ff       	call   80101425 <balloc>
80101cd3:	83 c4 10             	add    $0x10,%esp
80101cd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cd9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cdc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cdf:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101ce2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce5:	8b 00                	mov    (%eax),%eax
80101ce7:	83 ec 08             	sub    $0x8,%esp
80101cea:	ff 75 f4             	pushl  -0xc(%ebp)
80101ced:	50                   	push   %eax
80101cee:	e8 c3 e4 ff ff       	call   801001b6 <bread>
80101cf3:	83 c4 10             	add    $0x10,%esp
80101cf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cfc:	83 c0 18             	add    $0x18,%eax
80101cff:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101d02:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d05:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d0f:	01 d0                	add    %edx,%eax
80101d11:	8b 00                	mov    (%eax),%eax
80101d13:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d1a:	75 36                	jne    80101d52 <bmap+0xf8>
      a[bn] = addr = balloc(ip->dev);
80101d1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1f:	8b 00                	mov    (%eax),%eax
80101d21:	83 ec 0c             	sub    $0xc,%esp
80101d24:	50                   	push   %eax
80101d25:	e8 fb f6 ff ff       	call   80101425 <balloc>
80101d2a:	83 c4 10             	add    $0x10,%esp
80101d2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d30:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d33:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d3d:	01 c2                	add    %eax,%edx
80101d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d42:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101d44:	83 ec 0c             	sub    $0xc,%esp
80101d47:	ff 75 f0             	pushl  -0x10(%ebp)
80101d4a:	e8 3f 1a 00 00       	call   8010378e <log_write>
80101d4f:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101d52:	83 ec 0c             	sub    $0xc,%esp
80101d55:	ff 75 f0             	pushl  -0x10(%ebp)
80101d58:	e8 d1 e4 ff ff       	call   8010022e <brelse>
80101d5d:	83 c4 10             	add    $0x10,%esp
    return addr;
80101d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d63:	eb 0d                	jmp    80101d72 <bmap+0x118>
  }

  panic("bmap: out of range");
80101d65:	83 ec 0c             	sub    $0xc,%esp
80101d68:	68 e0 86 10 80       	push   $0x801086e0
80101d6d:	e8 f5 e7 ff ff       	call   80100567 <panic>
}
80101d72:	c9                   	leave  
80101d73:	c3                   	ret    

80101d74 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d74:	55                   	push   %ebp
80101d75:	89 e5                	mov    %esp,%ebp
80101d77:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d81:	eb 45                	jmp    80101dc8 <itrunc+0x54>
    if(ip->addrs[i]){
80101d83:	8b 45 08             	mov    0x8(%ebp),%eax
80101d86:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d89:	83 c2 04             	add    $0x4,%edx
80101d8c:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d90:	85 c0                	test   %eax,%eax
80101d92:	74 30                	je     80101dc4 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101d94:	8b 45 08             	mov    0x8(%ebp),%eax
80101d97:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d9a:	83 c2 04             	add    $0x4,%edx
80101d9d:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101da1:	8b 55 08             	mov    0x8(%ebp),%edx
80101da4:	8b 12                	mov    (%edx),%edx
80101da6:	83 ec 08             	sub    $0x8,%esp
80101da9:	50                   	push   %eax
80101daa:	52                   	push   %edx
80101dab:	e8 c1 f7 ff ff       	call   80101571 <bfree>
80101db0:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101db3:	8b 45 08             	mov    0x8(%ebp),%eax
80101db6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101db9:	83 c2 04             	add    $0x4,%edx
80101dbc:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101dc3:	00 
  for(i = 0; i < NDIRECT; i++){
80101dc4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101dc8:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101dcc:	7e b5                	jle    80101d83 <itrunc+0xf>
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101dce:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd1:	8b 40 4c             	mov    0x4c(%eax),%eax
80101dd4:	85 c0                	test   %eax,%eax
80101dd6:	0f 84 a1 00 00 00    	je     80101e7d <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101ddc:	8b 45 08             	mov    0x8(%ebp),%eax
80101ddf:	8b 50 4c             	mov    0x4c(%eax),%edx
80101de2:	8b 45 08             	mov    0x8(%ebp),%eax
80101de5:	8b 00                	mov    (%eax),%eax
80101de7:	83 ec 08             	sub    $0x8,%esp
80101dea:	52                   	push   %edx
80101deb:	50                   	push   %eax
80101dec:	e8 c5 e3 ff ff       	call   801001b6 <bread>
80101df1:	83 c4 10             	add    $0x10,%esp
80101df4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101df7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101dfa:	83 c0 18             	add    $0x18,%eax
80101dfd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e00:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101e07:	eb 3c                	jmp    80101e45 <itrunc+0xd1>
      if(a[j])
80101e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e0c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e13:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e16:	01 d0                	add    %edx,%eax
80101e18:	8b 00                	mov    (%eax),%eax
80101e1a:	85 c0                	test   %eax,%eax
80101e1c:	74 23                	je     80101e41 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101e1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e21:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e28:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e2b:	01 d0                	add    %edx,%eax
80101e2d:	8b 00                	mov    (%eax),%eax
80101e2f:	8b 55 08             	mov    0x8(%ebp),%edx
80101e32:	8b 12                	mov    (%edx),%edx
80101e34:	83 ec 08             	sub    $0x8,%esp
80101e37:	50                   	push   %eax
80101e38:	52                   	push   %edx
80101e39:	e8 33 f7 ff ff       	call   80101571 <bfree>
80101e3e:	83 c4 10             	add    $0x10,%esp
    for(j = 0; j < NINDIRECT; j++){
80101e41:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e48:	83 f8 7f             	cmp    $0x7f,%eax
80101e4b:	76 bc                	jbe    80101e09 <itrunc+0x95>
    }
    brelse(bp);
80101e4d:	83 ec 0c             	sub    $0xc,%esp
80101e50:	ff 75 ec             	pushl  -0x14(%ebp)
80101e53:	e8 d6 e3 ff ff       	call   8010022e <brelse>
80101e58:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e5b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e5e:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e61:	8b 55 08             	mov    0x8(%ebp),%edx
80101e64:	8b 12                	mov    (%edx),%edx
80101e66:	83 ec 08             	sub    $0x8,%esp
80101e69:	50                   	push   %eax
80101e6a:	52                   	push   %edx
80101e6b:	e8 01 f7 ff ff       	call   80101571 <bfree>
80101e70:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e73:	8b 45 08             	mov    0x8(%ebp),%eax
80101e76:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101e7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e80:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101e87:	83 ec 0c             	sub    $0xc,%esp
80101e8a:	ff 75 08             	pushl  0x8(%ebp)
80101e8d:	e8 09 f9 ff ff       	call   8010179b <iupdate>
80101e92:	83 c4 10             	add    $0x10,%esp
}
80101e95:	90                   	nop
80101e96:	c9                   	leave  
80101e97:	c3                   	ret    

80101e98 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101e98:	55                   	push   %ebp
80101e99:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101e9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9e:	8b 00                	mov    (%eax),%eax
80101ea0:	89 c2                	mov    %eax,%edx
80101ea2:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ea5:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101ea8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eab:	8b 50 04             	mov    0x4(%eax),%edx
80101eae:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eb1:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101eb4:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb7:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ebe:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101ec1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec4:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ecb:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101ecf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed2:	8b 50 18             	mov    0x18(%eax),%edx
80101ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ed8:	89 50 10             	mov    %edx,0x10(%eax)
}
80101edb:	90                   	nop
80101edc:	5d                   	pop    %ebp
80101edd:	c3                   	ret    

80101ede <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ede:	55                   	push   %ebp
80101edf:	89 e5                	mov    %esp,%ebp
80101ee1:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ee4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee7:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101eeb:	66 83 f8 03          	cmp    $0x3,%ax
80101eef:	75 5c                	jne    80101f4d <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ef1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef4:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ef8:	66 85 c0             	test   %ax,%ax
80101efb:	78 20                	js     80101f1d <readi+0x3f>
80101efd:	8b 45 08             	mov    0x8(%ebp),%eax
80101f00:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f04:	66 83 f8 09          	cmp    $0x9,%ax
80101f08:	7f 13                	jg     80101f1d <readi+0x3f>
80101f0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0d:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f11:	98                   	cwtl   
80101f12:	8b 04 c5 c0 11 11 80 	mov    -0x7feeee40(,%eax,8),%eax
80101f19:	85 c0                	test   %eax,%eax
80101f1b:	75 0a                	jne    80101f27 <readi+0x49>
      return -1;
80101f1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f22:	e9 0c 01 00 00       	jmp    80102033 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101f27:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2a:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f2e:	98                   	cwtl   
80101f2f:	8b 04 c5 c0 11 11 80 	mov    -0x7feeee40(,%eax,8),%eax
80101f36:	8b 55 14             	mov    0x14(%ebp),%edx
80101f39:	83 ec 04             	sub    $0x4,%esp
80101f3c:	52                   	push   %edx
80101f3d:	ff 75 0c             	pushl  0xc(%ebp)
80101f40:	ff 75 08             	pushl  0x8(%ebp)
80101f43:	ff d0                	call   *%eax
80101f45:	83 c4 10             	add    $0x10,%esp
80101f48:	e9 e6 00 00 00       	jmp    80102033 <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80101f4d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f50:	8b 40 18             	mov    0x18(%eax),%eax
80101f53:	39 45 10             	cmp    %eax,0x10(%ebp)
80101f56:	77 0d                	ja     80101f65 <readi+0x87>
80101f58:	8b 55 10             	mov    0x10(%ebp),%edx
80101f5b:	8b 45 14             	mov    0x14(%ebp),%eax
80101f5e:	01 d0                	add    %edx,%eax
80101f60:	39 45 10             	cmp    %eax,0x10(%ebp)
80101f63:	76 0a                	jbe    80101f6f <readi+0x91>
    return -1;
80101f65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f6a:	e9 c4 00 00 00       	jmp    80102033 <readi+0x155>
  if(off + n > ip->size)
80101f6f:	8b 55 10             	mov    0x10(%ebp),%edx
80101f72:	8b 45 14             	mov    0x14(%ebp),%eax
80101f75:	01 c2                	add    %eax,%edx
80101f77:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7a:	8b 40 18             	mov    0x18(%eax),%eax
80101f7d:	39 c2                	cmp    %eax,%edx
80101f7f:	76 0c                	jbe    80101f8d <readi+0xaf>
    n = ip->size - off;
80101f81:	8b 45 08             	mov    0x8(%ebp),%eax
80101f84:	8b 40 18             	mov    0x18(%eax),%eax
80101f87:	2b 45 10             	sub    0x10(%ebp),%eax
80101f8a:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f94:	e9 8b 00 00 00       	jmp    80102024 <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f99:	8b 45 10             	mov    0x10(%ebp),%eax
80101f9c:	c1 e8 09             	shr    $0x9,%eax
80101f9f:	83 ec 08             	sub    $0x8,%esp
80101fa2:	50                   	push   %eax
80101fa3:	ff 75 08             	pushl  0x8(%ebp)
80101fa6:	e8 af fc ff ff       	call   80101c5a <bmap>
80101fab:	83 c4 10             	add    $0x10,%esp
80101fae:	89 c2                	mov    %eax,%edx
80101fb0:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb3:	8b 00                	mov    (%eax),%eax
80101fb5:	83 ec 08             	sub    $0x8,%esp
80101fb8:	52                   	push   %edx
80101fb9:	50                   	push   %eax
80101fba:	e8 f7 e1 ff ff       	call   801001b6 <bread>
80101fbf:	83 c4 10             	add    $0x10,%esp
80101fc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fc5:	8b 45 10             	mov    0x10(%ebp),%eax
80101fc8:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fcd:	ba 00 02 00 00       	mov    $0x200,%edx
80101fd2:	29 c2                	sub    %eax,%edx
80101fd4:	8b 45 14             	mov    0x14(%ebp),%eax
80101fd7:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101fda:	39 c2                	cmp    %eax,%edx
80101fdc:	0f 46 c2             	cmovbe %edx,%eax
80101fdf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101fe2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fe5:	8d 50 18             	lea    0x18(%eax),%edx
80101fe8:	8b 45 10             	mov    0x10(%ebp),%eax
80101feb:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ff0:	01 d0                	add    %edx,%eax
80101ff2:	83 ec 04             	sub    $0x4,%esp
80101ff5:	ff 75 ec             	pushl  -0x14(%ebp)
80101ff8:	50                   	push   %eax
80101ff9:	ff 75 0c             	pushl  0xc(%ebp)
80101ffc:	e8 65 33 00 00       	call   80105366 <memmove>
80102001:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102004:	83 ec 0c             	sub    $0xc,%esp
80102007:	ff 75 f0             	pushl  -0x10(%ebp)
8010200a:	e8 1f e2 ff ff       	call   8010022e <brelse>
8010200f:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102012:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102015:	01 45 f4             	add    %eax,-0xc(%ebp)
80102018:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010201b:	01 45 10             	add    %eax,0x10(%ebp)
8010201e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102021:	01 45 0c             	add    %eax,0xc(%ebp)
80102024:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102027:	3b 45 14             	cmp    0x14(%ebp),%eax
8010202a:	0f 82 69 ff ff ff    	jb     80101f99 <readi+0xbb>
  }
  return n;
80102030:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102033:	c9                   	leave  
80102034:	c3                   	ret    

80102035 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102035:	55                   	push   %ebp
80102036:	89 e5                	mov    %esp,%ebp
80102038:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010203b:	8b 45 08             	mov    0x8(%ebp),%eax
8010203e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102042:	66 83 f8 03          	cmp    $0x3,%ax
80102046:	75 5c                	jne    801020a4 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102048:	8b 45 08             	mov    0x8(%ebp),%eax
8010204b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010204f:	66 85 c0             	test   %ax,%ax
80102052:	78 20                	js     80102074 <writei+0x3f>
80102054:	8b 45 08             	mov    0x8(%ebp),%eax
80102057:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010205b:	66 83 f8 09          	cmp    $0x9,%ax
8010205f:	7f 13                	jg     80102074 <writei+0x3f>
80102061:	8b 45 08             	mov    0x8(%ebp),%eax
80102064:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102068:	98                   	cwtl   
80102069:	8b 04 c5 c4 11 11 80 	mov    -0x7feeee3c(,%eax,8),%eax
80102070:	85 c0                	test   %eax,%eax
80102072:	75 0a                	jne    8010207e <writei+0x49>
      return -1;
80102074:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102079:	e9 3d 01 00 00       	jmp    801021bb <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
8010207e:	8b 45 08             	mov    0x8(%ebp),%eax
80102081:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102085:	98                   	cwtl   
80102086:	8b 04 c5 c4 11 11 80 	mov    -0x7feeee3c(,%eax,8),%eax
8010208d:	8b 55 14             	mov    0x14(%ebp),%edx
80102090:	83 ec 04             	sub    $0x4,%esp
80102093:	52                   	push   %edx
80102094:	ff 75 0c             	pushl  0xc(%ebp)
80102097:	ff 75 08             	pushl  0x8(%ebp)
8010209a:	ff d0                	call   *%eax
8010209c:	83 c4 10             	add    $0x10,%esp
8010209f:	e9 17 01 00 00       	jmp    801021bb <writei+0x186>
  }

  if(off > ip->size || off + n < off)
801020a4:	8b 45 08             	mov    0x8(%ebp),%eax
801020a7:	8b 40 18             	mov    0x18(%eax),%eax
801020aa:	39 45 10             	cmp    %eax,0x10(%ebp)
801020ad:	77 0d                	ja     801020bc <writei+0x87>
801020af:	8b 55 10             	mov    0x10(%ebp),%edx
801020b2:	8b 45 14             	mov    0x14(%ebp),%eax
801020b5:	01 d0                	add    %edx,%eax
801020b7:	39 45 10             	cmp    %eax,0x10(%ebp)
801020ba:	76 0a                	jbe    801020c6 <writei+0x91>
    return -1;
801020bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020c1:	e9 f5 00 00 00       	jmp    801021bb <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
801020c6:	8b 55 10             	mov    0x10(%ebp),%edx
801020c9:	8b 45 14             	mov    0x14(%ebp),%eax
801020cc:	01 d0                	add    %edx,%eax
801020ce:	3d 00 18 01 00       	cmp    $0x11800,%eax
801020d3:	76 0a                	jbe    801020df <writei+0xaa>
    return -1;
801020d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020da:	e9 dc 00 00 00       	jmp    801021bb <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020e6:	e9 99 00 00 00       	jmp    80102184 <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020eb:	8b 45 10             	mov    0x10(%ebp),%eax
801020ee:	c1 e8 09             	shr    $0x9,%eax
801020f1:	83 ec 08             	sub    $0x8,%esp
801020f4:	50                   	push   %eax
801020f5:	ff 75 08             	pushl  0x8(%ebp)
801020f8:	e8 5d fb ff ff       	call   80101c5a <bmap>
801020fd:	83 c4 10             	add    $0x10,%esp
80102100:	89 c2                	mov    %eax,%edx
80102102:	8b 45 08             	mov    0x8(%ebp),%eax
80102105:	8b 00                	mov    (%eax),%eax
80102107:	83 ec 08             	sub    $0x8,%esp
8010210a:	52                   	push   %edx
8010210b:	50                   	push   %eax
8010210c:	e8 a5 e0 ff ff       	call   801001b6 <bread>
80102111:	83 c4 10             	add    $0x10,%esp
80102114:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102117:	8b 45 10             	mov    0x10(%ebp),%eax
8010211a:	25 ff 01 00 00       	and    $0x1ff,%eax
8010211f:	ba 00 02 00 00       	mov    $0x200,%edx
80102124:	29 c2                	sub    %eax,%edx
80102126:	8b 45 14             	mov    0x14(%ebp),%eax
80102129:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010212c:	39 c2                	cmp    %eax,%edx
8010212e:	0f 46 c2             	cmovbe %edx,%eax
80102131:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102134:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102137:	8d 50 18             	lea    0x18(%eax),%edx
8010213a:	8b 45 10             	mov    0x10(%ebp),%eax
8010213d:	25 ff 01 00 00       	and    $0x1ff,%eax
80102142:	01 d0                	add    %edx,%eax
80102144:	83 ec 04             	sub    $0x4,%esp
80102147:	ff 75 ec             	pushl  -0x14(%ebp)
8010214a:	ff 75 0c             	pushl  0xc(%ebp)
8010214d:	50                   	push   %eax
8010214e:	e8 13 32 00 00       	call   80105366 <memmove>
80102153:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102156:	83 ec 0c             	sub    $0xc,%esp
80102159:	ff 75 f0             	pushl  -0x10(%ebp)
8010215c:	e8 2d 16 00 00       	call   8010378e <log_write>
80102161:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102164:	83 ec 0c             	sub    $0xc,%esp
80102167:	ff 75 f0             	pushl  -0x10(%ebp)
8010216a:	e8 bf e0 ff ff       	call   8010022e <brelse>
8010216f:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102172:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102175:	01 45 f4             	add    %eax,-0xc(%ebp)
80102178:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010217b:	01 45 10             	add    %eax,0x10(%ebp)
8010217e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102181:	01 45 0c             	add    %eax,0xc(%ebp)
80102184:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102187:	3b 45 14             	cmp    0x14(%ebp),%eax
8010218a:	0f 82 5b ff ff ff    	jb     801020eb <writei+0xb6>
  }

  if(n > 0 && off > ip->size){
80102190:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102194:	74 22                	je     801021b8 <writei+0x183>
80102196:	8b 45 08             	mov    0x8(%ebp),%eax
80102199:	8b 40 18             	mov    0x18(%eax),%eax
8010219c:	39 45 10             	cmp    %eax,0x10(%ebp)
8010219f:	76 17                	jbe    801021b8 <writei+0x183>
    ip->size = off;
801021a1:	8b 45 08             	mov    0x8(%ebp),%eax
801021a4:	8b 55 10             	mov    0x10(%ebp),%edx
801021a7:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
801021aa:	83 ec 0c             	sub    $0xc,%esp
801021ad:	ff 75 08             	pushl  0x8(%ebp)
801021b0:	e8 e6 f5 ff ff       	call   8010179b <iupdate>
801021b5:	83 c4 10             	add    $0x10,%esp
  }
  return n;
801021b8:	8b 45 14             	mov    0x14(%ebp),%eax
}
801021bb:	c9                   	leave  
801021bc:	c3                   	ret    

801021bd <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801021bd:	55                   	push   %ebp
801021be:	89 e5                	mov    %esp,%ebp
801021c0:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
801021c3:	83 ec 04             	sub    $0x4,%esp
801021c6:	6a 0e                	push   $0xe
801021c8:	ff 75 0c             	pushl  0xc(%ebp)
801021cb:	ff 75 08             	pushl  0x8(%ebp)
801021ce:	e8 29 32 00 00       	call   801053fc <strncmp>
801021d3:	83 c4 10             	add    $0x10,%esp
}
801021d6:	c9                   	leave  
801021d7:	c3                   	ret    

801021d8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801021d8:	55                   	push   %ebp
801021d9:	89 e5                	mov    %esp,%ebp
801021db:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801021de:	8b 45 08             	mov    0x8(%ebp),%eax
801021e1:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801021e5:	66 83 f8 01          	cmp    $0x1,%ax
801021e9:	74 0d                	je     801021f8 <dirlookup+0x20>
    panic("dirlookup not DIR");
801021eb:	83 ec 0c             	sub    $0xc,%esp
801021ee:	68 f3 86 10 80       	push   $0x801086f3
801021f3:	e8 6f e3 ff ff       	call   80100567 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801021f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021ff:	eb 7b                	jmp    8010227c <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102201:	6a 10                	push   $0x10
80102203:	ff 75 f4             	pushl  -0xc(%ebp)
80102206:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102209:	50                   	push   %eax
8010220a:	ff 75 08             	pushl  0x8(%ebp)
8010220d:	e8 cc fc ff ff       	call   80101ede <readi>
80102212:	83 c4 10             	add    $0x10,%esp
80102215:	83 f8 10             	cmp    $0x10,%eax
80102218:	74 0d                	je     80102227 <dirlookup+0x4f>
      panic("dirlink read");
8010221a:	83 ec 0c             	sub    $0xc,%esp
8010221d:	68 05 87 10 80       	push   $0x80108705
80102222:	e8 40 e3 ff ff       	call   80100567 <panic>
    if(de.inum == 0)
80102227:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010222b:	66 85 c0             	test   %ax,%ax
8010222e:	74 47                	je     80102277 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
80102230:	83 ec 08             	sub    $0x8,%esp
80102233:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102236:	83 c0 02             	add    $0x2,%eax
80102239:	50                   	push   %eax
8010223a:	ff 75 0c             	pushl  0xc(%ebp)
8010223d:	e8 7b ff ff ff       	call   801021bd <namecmp>
80102242:	83 c4 10             	add    $0x10,%esp
80102245:	85 c0                	test   %eax,%eax
80102247:	75 2f                	jne    80102278 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
80102249:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010224d:	74 08                	je     80102257 <dirlookup+0x7f>
        *poff = off;
8010224f:	8b 45 10             	mov    0x10(%ebp),%eax
80102252:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102255:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102257:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010225b:	0f b7 c0             	movzwl %ax,%eax
8010225e:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102261:	8b 45 08             	mov    0x8(%ebp),%eax
80102264:	8b 00                	mov    (%eax),%eax
80102266:	83 ec 08             	sub    $0x8,%esp
80102269:	ff 75 f0             	pushl  -0x10(%ebp)
8010226c:	50                   	push   %eax
8010226d:	e8 ea f5 ff ff       	call   8010185c <iget>
80102272:	83 c4 10             	add    $0x10,%esp
80102275:	eb 19                	jmp    80102290 <dirlookup+0xb8>
      continue;
80102277:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
80102278:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010227c:	8b 45 08             	mov    0x8(%ebp),%eax
8010227f:	8b 40 18             	mov    0x18(%eax),%eax
80102282:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102285:	0f 82 76 ff ff ff    	jb     80102201 <dirlookup+0x29>
    }
  }

  return 0;
8010228b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102290:	c9                   	leave  
80102291:	c3                   	ret    

80102292 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102292:	55                   	push   %ebp
80102293:	89 e5                	mov    %esp,%ebp
80102295:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102298:	83 ec 04             	sub    $0x4,%esp
8010229b:	6a 00                	push   $0x0
8010229d:	ff 75 0c             	pushl  0xc(%ebp)
801022a0:	ff 75 08             	pushl  0x8(%ebp)
801022a3:	e8 30 ff ff ff       	call   801021d8 <dirlookup>
801022a8:	83 c4 10             	add    $0x10,%esp
801022ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
801022ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801022b2:	74 18                	je     801022cc <dirlink+0x3a>
    iput(ip);
801022b4:	83 ec 0c             	sub    $0xc,%esp
801022b7:	ff 75 f0             	pushl  -0x10(%ebp)
801022ba:	e8 86 f8 ff ff       	call   80101b45 <iput>
801022bf:	83 c4 10             	add    $0x10,%esp
    return -1;
801022c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022c7:	e9 9c 00 00 00       	jmp    80102368 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801022cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022d3:	eb 39                	jmp    8010230e <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022d8:	6a 10                	push   $0x10
801022da:	50                   	push   %eax
801022db:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022de:	50                   	push   %eax
801022df:	ff 75 08             	pushl  0x8(%ebp)
801022e2:	e8 f7 fb ff ff       	call   80101ede <readi>
801022e7:	83 c4 10             	add    $0x10,%esp
801022ea:	83 f8 10             	cmp    $0x10,%eax
801022ed:	74 0d                	je     801022fc <dirlink+0x6a>
      panic("dirlink read");
801022ef:	83 ec 0c             	sub    $0xc,%esp
801022f2:	68 05 87 10 80       	push   $0x80108705
801022f7:	e8 6b e2 ff ff       	call   80100567 <panic>
    if(de.inum == 0)
801022fc:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102300:	66 85 c0             	test   %ax,%ax
80102303:	74 18                	je     8010231d <dirlink+0x8b>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102305:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102308:	83 c0 10             	add    $0x10,%eax
8010230b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010230e:	8b 45 08             	mov    0x8(%ebp),%eax
80102311:	8b 50 18             	mov    0x18(%eax),%edx
80102314:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102317:	39 c2                	cmp    %eax,%edx
80102319:	77 ba                	ja     801022d5 <dirlink+0x43>
8010231b:	eb 01                	jmp    8010231e <dirlink+0x8c>
      break;
8010231d:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
8010231e:	83 ec 04             	sub    $0x4,%esp
80102321:	6a 0e                	push   $0xe
80102323:	ff 75 0c             	pushl  0xc(%ebp)
80102326:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102329:	83 c0 02             	add    $0x2,%eax
8010232c:	50                   	push   %eax
8010232d:	e8 20 31 00 00       	call   80105452 <strncpy>
80102332:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
80102335:	8b 45 10             	mov    0x10(%ebp),%eax
80102338:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010233f:	6a 10                	push   $0x10
80102341:	50                   	push   %eax
80102342:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102345:	50                   	push   %eax
80102346:	ff 75 08             	pushl  0x8(%ebp)
80102349:	e8 e7 fc ff ff       	call   80102035 <writei>
8010234e:	83 c4 10             	add    $0x10,%esp
80102351:	83 f8 10             	cmp    $0x10,%eax
80102354:	74 0d                	je     80102363 <dirlink+0xd1>
    panic("dirlink");
80102356:	83 ec 0c             	sub    $0xc,%esp
80102359:	68 12 87 10 80       	push   $0x80108712
8010235e:	e8 04 e2 ff ff       	call   80100567 <panic>
  
  return 0;
80102363:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102368:	c9                   	leave  
80102369:	c3                   	ret    

8010236a <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010236a:	55                   	push   %ebp
8010236b:	89 e5                	mov    %esp,%ebp
8010236d:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102370:	eb 04                	jmp    80102376 <skipelem+0xc>
    path++;
80102372:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
80102376:	8b 45 08             	mov    0x8(%ebp),%eax
80102379:	0f b6 00             	movzbl (%eax),%eax
8010237c:	3c 2f                	cmp    $0x2f,%al
8010237e:	74 f2                	je     80102372 <skipelem+0x8>
  if(*path == 0)
80102380:	8b 45 08             	mov    0x8(%ebp),%eax
80102383:	0f b6 00             	movzbl (%eax),%eax
80102386:	84 c0                	test   %al,%al
80102388:	75 07                	jne    80102391 <skipelem+0x27>
    return 0;
8010238a:	b8 00 00 00 00       	mov    $0x0,%eax
8010238f:	eb 77                	jmp    80102408 <skipelem+0x9e>
  s = path;
80102391:	8b 45 08             	mov    0x8(%ebp),%eax
80102394:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102397:	eb 04                	jmp    8010239d <skipelem+0x33>
    path++;
80102399:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
8010239d:	8b 45 08             	mov    0x8(%ebp),%eax
801023a0:	0f b6 00             	movzbl (%eax),%eax
801023a3:	3c 2f                	cmp    $0x2f,%al
801023a5:	74 0a                	je     801023b1 <skipelem+0x47>
801023a7:	8b 45 08             	mov    0x8(%ebp),%eax
801023aa:	0f b6 00             	movzbl (%eax),%eax
801023ad:	84 c0                	test   %al,%al
801023af:	75 e8                	jne    80102399 <skipelem+0x2f>
  len = path - s;
801023b1:	8b 45 08             	mov    0x8(%ebp),%eax
801023b4:	2b 45 f4             	sub    -0xc(%ebp),%eax
801023b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801023ba:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801023be:	7e 15                	jle    801023d5 <skipelem+0x6b>
    memmove(name, s, DIRSIZ);
801023c0:	83 ec 04             	sub    $0x4,%esp
801023c3:	6a 0e                	push   $0xe
801023c5:	ff 75 f4             	pushl  -0xc(%ebp)
801023c8:	ff 75 0c             	pushl  0xc(%ebp)
801023cb:	e8 96 2f 00 00       	call   80105366 <memmove>
801023d0:	83 c4 10             	add    $0x10,%esp
801023d3:	eb 26                	jmp    801023fb <skipelem+0x91>
  else {
    memmove(name, s, len);
801023d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023d8:	83 ec 04             	sub    $0x4,%esp
801023db:	50                   	push   %eax
801023dc:	ff 75 f4             	pushl  -0xc(%ebp)
801023df:	ff 75 0c             	pushl  0xc(%ebp)
801023e2:	e8 7f 2f 00 00       	call   80105366 <memmove>
801023e7:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
801023ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
801023ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801023f0:	01 d0                	add    %edx,%eax
801023f2:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801023f5:	eb 04                	jmp    801023fb <skipelem+0x91>
    path++;
801023f7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
801023fb:	8b 45 08             	mov    0x8(%ebp),%eax
801023fe:	0f b6 00             	movzbl (%eax),%eax
80102401:	3c 2f                	cmp    $0x2f,%al
80102403:	74 f2                	je     801023f7 <skipelem+0x8d>
  return path;
80102405:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102408:	c9                   	leave  
80102409:	c3                   	ret    

8010240a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
8010240a:	55                   	push   %ebp
8010240b:	89 e5                	mov    %esp,%ebp
8010240d:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102410:	8b 45 08             	mov    0x8(%ebp),%eax
80102413:	0f b6 00             	movzbl (%eax),%eax
80102416:	3c 2f                	cmp    $0x2f,%al
80102418:	75 17                	jne    80102431 <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
8010241a:	83 ec 08             	sub    $0x8,%esp
8010241d:	6a 01                	push   $0x1
8010241f:	6a 01                	push   $0x1
80102421:	e8 36 f4 ff ff       	call   8010185c <iget>
80102426:	83 c4 10             	add    $0x10,%esp
80102429:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010242c:	e9 bb 00 00 00       	jmp    801024ec <namex+0xe2>
  else
    ip = idup(proc->cwd);
80102431:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102437:	8b 40 68             	mov    0x68(%eax),%eax
8010243a:	83 ec 0c             	sub    $0xc,%esp
8010243d:	50                   	push   %eax
8010243e:	e8 f8 f4 ff ff       	call   8010193b <idup>
80102443:	83 c4 10             	add    $0x10,%esp
80102446:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102449:	e9 9e 00 00 00       	jmp    801024ec <namex+0xe2>
    ilock(ip);
8010244e:	83 ec 0c             	sub    $0xc,%esp
80102451:	ff 75 f4             	pushl  -0xc(%ebp)
80102454:	e8 1c f5 ff ff       	call   80101975 <ilock>
80102459:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
8010245c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010245f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102463:	66 83 f8 01          	cmp    $0x1,%ax
80102467:	74 18                	je     80102481 <namex+0x77>
      iunlockput(ip);
80102469:	83 ec 0c             	sub    $0xc,%esp
8010246c:	ff 75 f4             	pushl  -0xc(%ebp)
8010246f:	e8 c1 f7 ff ff       	call   80101c35 <iunlockput>
80102474:	83 c4 10             	add    $0x10,%esp
      return 0;
80102477:	b8 00 00 00 00       	mov    $0x0,%eax
8010247c:	e9 a7 00 00 00       	jmp    80102528 <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
80102481:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102485:	74 20                	je     801024a7 <namex+0x9d>
80102487:	8b 45 08             	mov    0x8(%ebp),%eax
8010248a:	0f b6 00             	movzbl (%eax),%eax
8010248d:	84 c0                	test   %al,%al
8010248f:	75 16                	jne    801024a7 <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
80102491:	83 ec 0c             	sub    $0xc,%esp
80102494:	ff 75 f4             	pushl  -0xc(%ebp)
80102497:	e8 37 f6 ff ff       	call   80101ad3 <iunlock>
8010249c:	83 c4 10             	add    $0x10,%esp
      return ip;
8010249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024a2:	e9 81 00 00 00       	jmp    80102528 <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801024a7:	83 ec 04             	sub    $0x4,%esp
801024aa:	6a 00                	push   $0x0
801024ac:	ff 75 10             	pushl  0x10(%ebp)
801024af:	ff 75 f4             	pushl  -0xc(%ebp)
801024b2:	e8 21 fd ff ff       	call   801021d8 <dirlookup>
801024b7:	83 c4 10             	add    $0x10,%esp
801024ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
801024bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801024c1:	75 15                	jne    801024d8 <namex+0xce>
      iunlockput(ip);
801024c3:	83 ec 0c             	sub    $0xc,%esp
801024c6:	ff 75 f4             	pushl  -0xc(%ebp)
801024c9:	e8 67 f7 ff ff       	call   80101c35 <iunlockput>
801024ce:	83 c4 10             	add    $0x10,%esp
      return 0;
801024d1:	b8 00 00 00 00       	mov    $0x0,%eax
801024d6:	eb 50                	jmp    80102528 <namex+0x11e>
    }
    iunlockput(ip);
801024d8:	83 ec 0c             	sub    $0xc,%esp
801024db:	ff 75 f4             	pushl  -0xc(%ebp)
801024de:	e8 52 f7 ff ff       	call   80101c35 <iunlockput>
801024e3:	83 c4 10             	add    $0x10,%esp
    ip = next;
801024e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801024e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
801024ec:	83 ec 08             	sub    $0x8,%esp
801024ef:	ff 75 10             	pushl  0x10(%ebp)
801024f2:	ff 75 08             	pushl  0x8(%ebp)
801024f5:	e8 70 fe ff ff       	call   8010236a <skipelem>
801024fa:	83 c4 10             	add    $0x10,%esp
801024fd:	89 45 08             	mov    %eax,0x8(%ebp)
80102500:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102504:	0f 85 44 ff ff ff    	jne    8010244e <namex+0x44>
  }
  if(nameiparent){
8010250a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010250e:	74 15                	je     80102525 <namex+0x11b>
    iput(ip);
80102510:	83 ec 0c             	sub    $0xc,%esp
80102513:	ff 75 f4             	pushl  -0xc(%ebp)
80102516:	e8 2a f6 ff ff       	call   80101b45 <iput>
8010251b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010251e:	b8 00 00 00 00       	mov    $0x0,%eax
80102523:	eb 03                	jmp    80102528 <namex+0x11e>
  }
  return ip;
80102525:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102528:	c9                   	leave  
80102529:	c3                   	ret    

8010252a <namei>:

struct inode*
namei(char *path)
{
8010252a:	55                   	push   %ebp
8010252b:	89 e5                	mov    %esp,%ebp
8010252d:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102530:	83 ec 04             	sub    $0x4,%esp
80102533:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102536:	50                   	push   %eax
80102537:	6a 00                	push   $0x0
80102539:	ff 75 08             	pushl  0x8(%ebp)
8010253c:	e8 c9 fe ff ff       	call   8010240a <namex>
80102541:	83 c4 10             	add    $0x10,%esp
}
80102544:	c9                   	leave  
80102545:	c3                   	ret    

80102546 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102546:	55                   	push   %ebp
80102547:	89 e5                	mov    %esp,%ebp
80102549:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
8010254c:	83 ec 04             	sub    $0x4,%esp
8010254f:	ff 75 0c             	pushl  0xc(%ebp)
80102552:	6a 01                	push   $0x1
80102554:	ff 75 08             	pushl  0x8(%ebp)
80102557:	e8 ae fe ff ff       	call   8010240a <namex>
8010255c:	83 c4 10             	add    $0x10,%esp
}
8010255f:	c9                   	leave  
80102560:	c3                   	ret    

80102561 <inb>:
{
80102561:	55                   	push   %ebp
80102562:	89 e5                	mov    %esp,%ebp
80102564:	83 ec 14             	sub    $0x14,%esp
80102567:	8b 45 08             	mov    0x8(%ebp),%eax
8010256a:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010256e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102572:	89 c2                	mov    %eax,%edx
80102574:	ec                   	in     (%dx),%al
80102575:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102578:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010257c:	c9                   	leave  
8010257d:	c3                   	ret    

8010257e <insl>:
{
8010257e:	55                   	push   %ebp
8010257f:	89 e5                	mov    %esp,%ebp
80102581:	57                   	push   %edi
80102582:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102583:	8b 55 08             	mov    0x8(%ebp),%edx
80102586:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102589:	8b 45 10             	mov    0x10(%ebp),%eax
8010258c:	89 cb                	mov    %ecx,%ebx
8010258e:	89 df                	mov    %ebx,%edi
80102590:	89 c1                	mov    %eax,%ecx
80102592:	fc                   	cld    
80102593:	f3 6d                	rep insl (%dx),%es:(%edi)
80102595:	89 c8                	mov    %ecx,%eax
80102597:	89 fb                	mov    %edi,%ebx
80102599:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010259c:	89 45 10             	mov    %eax,0x10(%ebp)
}
8010259f:	90                   	nop
801025a0:	5b                   	pop    %ebx
801025a1:	5f                   	pop    %edi
801025a2:	5d                   	pop    %ebp
801025a3:	c3                   	ret    

801025a4 <outb>:
{
801025a4:	55                   	push   %ebp
801025a5:	89 e5                	mov    %esp,%ebp
801025a7:	83 ec 08             	sub    $0x8,%esp
801025aa:	8b 45 08             	mov    0x8(%ebp),%eax
801025ad:	8b 55 0c             	mov    0xc(%ebp),%edx
801025b0:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801025b4:	89 d0                	mov    %edx,%eax
801025b6:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025b9:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801025bd:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801025c1:	ee                   	out    %al,(%dx)
}
801025c2:	90                   	nop
801025c3:	c9                   	leave  
801025c4:	c3                   	ret    

801025c5 <outsl>:
{
801025c5:	55                   	push   %ebp
801025c6:	89 e5                	mov    %esp,%ebp
801025c8:	56                   	push   %esi
801025c9:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801025ca:	8b 55 08             	mov    0x8(%ebp),%edx
801025cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025d0:	8b 45 10             	mov    0x10(%ebp),%eax
801025d3:	89 cb                	mov    %ecx,%ebx
801025d5:	89 de                	mov    %ebx,%esi
801025d7:	89 c1                	mov    %eax,%ecx
801025d9:	fc                   	cld    
801025da:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801025dc:	89 c8                	mov    %ecx,%eax
801025de:	89 f3                	mov    %esi,%ebx
801025e0:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801025e3:	89 45 10             	mov    %eax,0x10(%ebp)
}
801025e6:	90                   	nop
801025e7:	5b                   	pop    %ebx
801025e8:	5e                   	pop    %esi
801025e9:	5d                   	pop    %ebp
801025ea:	c3                   	ret    

801025eb <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801025eb:	55                   	push   %ebp
801025ec:	89 e5                	mov    %esp,%ebp
801025ee:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801025f1:	90                   	nop
801025f2:	68 f7 01 00 00       	push   $0x1f7
801025f7:	e8 65 ff ff ff       	call   80102561 <inb>
801025fc:	83 c4 04             	add    $0x4,%esp
801025ff:	0f b6 c0             	movzbl %al,%eax
80102602:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102605:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102608:	25 c0 00 00 00       	and    $0xc0,%eax
8010260d:	83 f8 40             	cmp    $0x40,%eax
80102610:	75 e0                	jne    801025f2 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102612:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102616:	74 11                	je     80102629 <idewait+0x3e>
80102618:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010261b:	83 e0 21             	and    $0x21,%eax
8010261e:	85 c0                	test   %eax,%eax
80102620:	74 07                	je     80102629 <idewait+0x3e>
    return -1;
80102622:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102627:	eb 05                	jmp    8010262e <idewait+0x43>
  return 0;
80102629:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010262e:	c9                   	leave  
8010262f:	c3                   	ret    

80102630 <ideinit>:

void
ideinit(void)
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
80102636:	83 ec 08             	sub    $0x8,%esp
80102639:	68 1a 87 10 80       	push   $0x8010871a
8010263e:	68 00 b6 10 80       	push   $0x8010b600
80102643:	e8 da 29 00 00       	call   80105022 <initlock>
80102648:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
8010264b:	83 ec 0c             	sub    $0xc,%esp
8010264e:	6a 0e                	push   $0xe
80102650:	e8 eb 18 00 00       	call   80103f40 <picenable>
80102655:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
80102658:	a1 40 29 11 80       	mov    0x80112940,%eax
8010265d:	83 e8 01             	sub    $0x1,%eax
80102660:	83 ec 08             	sub    $0x8,%esp
80102663:	50                   	push   %eax
80102664:	6a 0e                	push   $0xe
80102666:	e8 73 04 00 00       	call   80102ade <ioapicenable>
8010266b:	83 c4 10             	add    $0x10,%esp
  idewait(0);
8010266e:	83 ec 0c             	sub    $0xc,%esp
80102671:	6a 00                	push   $0x0
80102673:	e8 73 ff ff ff       	call   801025eb <idewait>
80102678:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010267b:	83 ec 08             	sub    $0x8,%esp
8010267e:	68 f0 00 00 00       	push   $0xf0
80102683:	68 f6 01 00 00       	push   $0x1f6
80102688:	e8 17 ff ff ff       	call   801025a4 <outb>
8010268d:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
80102690:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102697:	eb 24                	jmp    801026bd <ideinit+0x8d>
    if(inb(0x1f7) != 0){
80102699:	83 ec 0c             	sub    $0xc,%esp
8010269c:	68 f7 01 00 00       	push   $0x1f7
801026a1:	e8 bb fe ff ff       	call   80102561 <inb>
801026a6:	83 c4 10             	add    $0x10,%esp
801026a9:	84 c0                	test   %al,%al
801026ab:	74 0c                	je     801026b9 <ideinit+0x89>
      havedisk1 = 1;
801026ad:	c7 05 38 b6 10 80 01 	movl   $0x1,0x8010b638
801026b4:	00 00 00 
      break;
801026b7:	eb 0d                	jmp    801026c6 <ideinit+0x96>
  for(i=0; i<1000; i++){
801026b9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801026bd:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801026c4:	7e d3                	jle    80102699 <ideinit+0x69>
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801026c6:	83 ec 08             	sub    $0x8,%esp
801026c9:	68 e0 00 00 00       	push   $0xe0
801026ce:	68 f6 01 00 00       	push   $0x1f6
801026d3:	e8 cc fe ff ff       	call   801025a4 <outb>
801026d8:	83 c4 10             	add    $0x10,%esp
}
801026db:	90                   	nop
801026dc:	c9                   	leave  
801026dd:	c3                   	ret    

801026de <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801026de:	55                   	push   %ebp
801026df:	89 e5                	mov    %esp,%ebp
801026e1:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801026e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026e8:	75 0d                	jne    801026f7 <idestart+0x19>
    panic("idestart");
801026ea:	83 ec 0c             	sub    $0xc,%esp
801026ed:	68 1e 87 10 80       	push   $0x8010871e
801026f2:	e8 70 de ff ff       	call   80100567 <panic>
  if(b->blockno >= FSSIZE)
801026f7:	8b 45 08             	mov    0x8(%ebp),%eax
801026fa:	8b 40 08             	mov    0x8(%eax),%eax
801026fd:	3d e7 03 00 00       	cmp    $0x3e7,%eax
80102702:	76 0d                	jbe    80102711 <idestart+0x33>
    panic("incorrect blockno");
80102704:	83 ec 0c             	sub    $0xc,%esp
80102707:	68 27 87 10 80       	push   $0x80108727
8010270c:	e8 56 de ff ff       	call   80100567 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102711:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102718:	8b 45 08             	mov    0x8(%ebp),%eax
8010271b:	8b 50 08             	mov    0x8(%eax),%edx
8010271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102721:	0f af c2             	imul   %edx,%eax
80102724:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102727:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
8010272b:	7e 0d                	jle    8010273a <idestart+0x5c>
8010272d:	83 ec 0c             	sub    $0xc,%esp
80102730:	68 1e 87 10 80       	push   $0x8010871e
80102735:	e8 2d de ff ff       	call   80100567 <panic>
  
  idewait(0);
8010273a:	83 ec 0c             	sub    $0xc,%esp
8010273d:	6a 00                	push   $0x0
8010273f:	e8 a7 fe ff ff       	call   801025eb <idewait>
80102744:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102747:	83 ec 08             	sub    $0x8,%esp
8010274a:	6a 00                	push   $0x0
8010274c:	68 f6 03 00 00       	push   $0x3f6
80102751:	e8 4e fe ff ff       	call   801025a4 <outb>
80102756:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
80102759:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010275c:	0f b6 c0             	movzbl %al,%eax
8010275f:	83 ec 08             	sub    $0x8,%esp
80102762:	50                   	push   %eax
80102763:	68 f2 01 00 00       	push   $0x1f2
80102768:	e8 37 fe ff ff       	call   801025a4 <outb>
8010276d:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
80102770:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102773:	0f b6 c0             	movzbl %al,%eax
80102776:	83 ec 08             	sub    $0x8,%esp
80102779:	50                   	push   %eax
8010277a:	68 f3 01 00 00       	push   $0x1f3
8010277f:	e8 20 fe ff ff       	call   801025a4 <outb>
80102784:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102787:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010278a:	c1 f8 08             	sar    $0x8,%eax
8010278d:	0f b6 c0             	movzbl %al,%eax
80102790:	83 ec 08             	sub    $0x8,%esp
80102793:	50                   	push   %eax
80102794:	68 f4 01 00 00       	push   $0x1f4
80102799:	e8 06 fe ff ff       	call   801025a4 <outb>
8010279e:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
801027a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027a4:	c1 f8 10             	sar    $0x10,%eax
801027a7:	0f b6 c0             	movzbl %al,%eax
801027aa:	83 ec 08             	sub    $0x8,%esp
801027ad:	50                   	push   %eax
801027ae:	68 f5 01 00 00       	push   $0x1f5
801027b3:	e8 ec fd ff ff       	call   801025a4 <outb>
801027b8:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801027bb:	8b 45 08             	mov    0x8(%ebp),%eax
801027be:	8b 40 04             	mov    0x4(%eax),%eax
801027c1:	c1 e0 04             	shl    $0x4,%eax
801027c4:	83 e0 10             	and    $0x10,%eax
801027c7:	89 c2                	mov    %eax,%edx
801027c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027cc:	c1 f8 18             	sar    $0x18,%eax
801027cf:	83 e0 0f             	and    $0xf,%eax
801027d2:	09 d0                	or     %edx,%eax
801027d4:	83 c8 e0             	or     $0xffffffe0,%eax
801027d7:	0f b6 c0             	movzbl %al,%eax
801027da:	83 ec 08             	sub    $0x8,%esp
801027dd:	50                   	push   %eax
801027de:	68 f6 01 00 00       	push   $0x1f6
801027e3:	e8 bc fd ff ff       	call   801025a4 <outb>
801027e8:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
801027eb:	8b 45 08             	mov    0x8(%ebp),%eax
801027ee:	8b 00                	mov    (%eax),%eax
801027f0:	83 e0 04             	and    $0x4,%eax
801027f3:	85 c0                	test   %eax,%eax
801027f5:	74 30                	je     80102827 <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
801027f7:	83 ec 08             	sub    $0x8,%esp
801027fa:	6a 30                	push   $0x30
801027fc:	68 f7 01 00 00       	push   $0x1f7
80102801:	e8 9e fd ff ff       	call   801025a4 <outb>
80102806:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
80102809:	8b 45 08             	mov    0x8(%ebp),%eax
8010280c:	83 c0 18             	add    $0x18,%eax
8010280f:	83 ec 04             	sub    $0x4,%esp
80102812:	68 80 00 00 00       	push   $0x80
80102817:	50                   	push   %eax
80102818:	68 f0 01 00 00       	push   $0x1f0
8010281d:	e8 a3 fd ff ff       	call   801025c5 <outsl>
80102822:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
80102825:	eb 12                	jmp    80102839 <idestart+0x15b>
    outb(0x1f7, IDE_CMD_READ);
80102827:	83 ec 08             	sub    $0x8,%esp
8010282a:	6a 20                	push   $0x20
8010282c:	68 f7 01 00 00       	push   $0x1f7
80102831:	e8 6e fd ff ff       	call   801025a4 <outb>
80102836:	83 c4 10             	add    $0x10,%esp
}
80102839:	90                   	nop
8010283a:	c9                   	leave  
8010283b:	c3                   	ret    

8010283c <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010283c:	55                   	push   %ebp
8010283d:	89 e5                	mov    %esp,%ebp
8010283f:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102842:	83 ec 0c             	sub    $0xc,%esp
80102845:	68 00 b6 10 80       	push   $0x8010b600
8010284a:	e8 f5 27 00 00       	call   80105044 <acquire>
8010284f:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
80102852:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102857:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010285a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010285e:	75 15                	jne    80102875 <ideintr+0x39>
    release(&idelock);
80102860:	83 ec 0c             	sub    $0xc,%esp
80102863:	68 00 b6 10 80       	push   $0x8010b600
80102868:	e8 3e 28 00 00       	call   801050ab <release>
8010286d:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102870:	e9 9a 00 00 00       	jmp    8010290f <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102875:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102878:	8b 40 14             	mov    0x14(%eax),%eax
8010287b:	a3 34 b6 10 80       	mov    %eax,0x8010b634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102880:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102883:	8b 00                	mov    (%eax),%eax
80102885:	83 e0 04             	and    $0x4,%eax
80102888:	85 c0                	test   %eax,%eax
8010288a:	75 2d                	jne    801028b9 <ideintr+0x7d>
8010288c:	83 ec 0c             	sub    $0xc,%esp
8010288f:	6a 01                	push   $0x1
80102891:	e8 55 fd ff ff       	call   801025eb <idewait>
80102896:	83 c4 10             	add    $0x10,%esp
80102899:	85 c0                	test   %eax,%eax
8010289b:	78 1c                	js     801028b9 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
8010289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028a0:	83 c0 18             	add    $0x18,%eax
801028a3:	83 ec 04             	sub    $0x4,%esp
801028a6:	68 80 00 00 00       	push   $0x80
801028ab:	50                   	push   %eax
801028ac:	68 f0 01 00 00       	push   $0x1f0
801028b1:	e8 c8 fc ff ff       	call   8010257e <insl>
801028b6:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028bc:	8b 00                	mov    (%eax),%eax
801028be:	83 c8 02             	or     $0x2,%eax
801028c1:	89 c2                	mov    %eax,%edx
801028c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028c6:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028cb:	8b 00                	mov    (%eax),%eax
801028cd:	83 e0 fb             	and    $0xfffffffb,%eax
801028d0:	89 c2                	mov    %eax,%edx
801028d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028d5:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801028d7:	83 ec 0c             	sub    $0xc,%esp
801028da:	ff 75 f4             	pushl  -0xc(%ebp)
801028dd:	e8 54 25 00 00       	call   80104e36 <wakeup>
801028e2:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
801028e5:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801028ea:	85 c0                	test   %eax,%eax
801028ec:	74 11                	je     801028ff <ideintr+0xc3>
    idestart(idequeue);
801028ee:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801028f3:	83 ec 0c             	sub    $0xc,%esp
801028f6:	50                   	push   %eax
801028f7:	e8 e2 fd ff ff       	call   801026de <idestart>
801028fc:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
801028ff:	83 ec 0c             	sub    $0xc,%esp
80102902:	68 00 b6 10 80       	push   $0x8010b600
80102907:	e8 9f 27 00 00       	call   801050ab <release>
8010290c:	83 c4 10             	add    $0x10,%esp
}
8010290f:	c9                   	leave  
80102910:	c3                   	ret    

80102911 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102911:	55                   	push   %ebp
80102912:	89 e5                	mov    %esp,%ebp
80102914:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102917:	8b 45 08             	mov    0x8(%ebp),%eax
8010291a:	8b 00                	mov    (%eax),%eax
8010291c:	83 e0 01             	and    $0x1,%eax
8010291f:	85 c0                	test   %eax,%eax
80102921:	75 0d                	jne    80102930 <iderw+0x1f>
    panic("iderw: buf not busy");
80102923:	83 ec 0c             	sub    $0xc,%esp
80102926:	68 39 87 10 80       	push   $0x80108739
8010292b:	e8 37 dc ff ff       	call   80100567 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102930:	8b 45 08             	mov    0x8(%ebp),%eax
80102933:	8b 00                	mov    (%eax),%eax
80102935:	83 e0 06             	and    $0x6,%eax
80102938:	83 f8 02             	cmp    $0x2,%eax
8010293b:	75 0d                	jne    8010294a <iderw+0x39>
    panic("iderw: nothing to do");
8010293d:	83 ec 0c             	sub    $0xc,%esp
80102940:	68 4d 87 10 80       	push   $0x8010874d
80102945:	e8 1d dc ff ff       	call   80100567 <panic>
  if(b->dev != 0 && !havedisk1)
8010294a:	8b 45 08             	mov    0x8(%ebp),%eax
8010294d:	8b 40 04             	mov    0x4(%eax),%eax
80102950:	85 c0                	test   %eax,%eax
80102952:	74 16                	je     8010296a <iderw+0x59>
80102954:	a1 38 b6 10 80       	mov    0x8010b638,%eax
80102959:	85 c0                	test   %eax,%eax
8010295b:	75 0d                	jne    8010296a <iderw+0x59>
    panic("iderw: ide disk 1 not present");
8010295d:	83 ec 0c             	sub    $0xc,%esp
80102960:	68 62 87 10 80       	push   $0x80108762
80102965:	e8 fd db ff ff       	call   80100567 <panic>

  acquire(&idelock);  //DOC:acquire-lock
8010296a:	83 ec 0c             	sub    $0xc,%esp
8010296d:	68 00 b6 10 80       	push   $0x8010b600
80102972:	e8 cd 26 00 00       	call   80105044 <acquire>
80102977:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
8010297a:	8b 45 08             	mov    0x8(%ebp),%eax
8010297d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102984:	c7 45 f4 34 b6 10 80 	movl   $0x8010b634,-0xc(%ebp)
8010298b:	eb 0b                	jmp    80102998 <iderw+0x87>
8010298d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102990:	8b 00                	mov    (%eax),%eax
80102992:	83 c0 14             	add    $0x14,%eax
80102995:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102998:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010299b:	8b 00                	mov    (%eax),%eax
8010299d:	85 c0                	test   %eax,%eax
8010299f:	75 ec                	jne    8010298d <iderw+0x7c>
    ;
  *pp = b;
801029a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029a4:	8b 55 08             	mov    0x8(%ebp),%edx
801029a7:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
801029a9:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801029ae:	39 45 08             	cmp    %eax,0x8(%ebp)
801029b1:	75 23                	jne    801029d6 <iderw+0xc5>
    idestart(b);
801029b3:	83 ec 0c             	sub    $0xc,%esp
801029b6:	ff 75 08             	pushl  0x8(%ebp)
801029b9:	e8 20 fd ff ff       	call   801026de <idestart>
801029be:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801029c1:	eb 13                	jmp    801029d6 <iderw+0xc5>
    sleep(b, &idelock);
801029c3:	83 ec 08             	sub    $0x8,%esp
801029c6:	68 00 b6 10 80       	push   $0x8010b600
801029cb:	ff 75 08             	pushl  0x8(%ebp)
801029ce:	e8 78 23 00 00       	call   80104d4b <sleep>
801029d3:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801029d6:	8b 45 08             	mov    0x8(%ebp),%eax
801029d9:	8b 00                	mov    (%eax),%eax
801029db:	83 e0 06             	and    $0x6,%eax
801029de:	83 f8 02             	cmp    $0x2,%eax
801029e1:	75 e0                	jne    801029c3 <iderw+0xb2>
  }

  release(&idelock);
801029e3:	83 ec 0c             	sub    $0xc,%esp
801029e6:	68 00 b6 10 80       	push   $0x8010b600
801029eb:	e8 bb 26 00 00       	call   801050ab <release>
801029f0:	83 c4 10             	add    $0x10,%esp
}
801029f3:	90                   	nop
801029f4:	c9                   	leave  
801029f5:	c3                   	ret    

801029f6 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
801029f6:	55                   	push   %ebp
801029f7:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801029f9:	a1 14 22 11 80       	mov    0x80112214,%eax
801029fe:	8b 55 08             	mov    0x8(%ebp),%edx
80102a01:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102a03:	a1 14 22 11 80       	mov    0x80112214,%eax
80102a08:	8b 40 10             	mov    0x10(%eax),%eax
}
80102a0b:	5d                   	pop    %ebp
80102a0c:	c3                   	ret    

80102a0d <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102a0d:	55                   	push   %ebp
80102a0e:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a10:	a1 14 22 11 80       	mov    0x80112214,%eax
80102a15:	8b 55 08             	mov    0x8(%ebp),%edx
80102a18:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102a1a:	a1 14 22 11 80       	mov    0x80112214,%eax
80102a1f:	8b 55 0c             	mov    0xc(%ebp),%edx
80102a22:	89 50 10             	mov    %edx,0x10(%eax)
}
80102a25:	90                   	nop
80102a26:	5d                   	pop    %ebp
80102a27:	c3                   	ret    

80102a28 <ioapicinit>:

void
ioapicinit(void)
{
80102a28:	55                   	push   %ebp
80102a29:	89 e5                	mov    %esp,%ebp
80102a2b:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102a2e:	a1 44 23 11 80       	mov    0x80112344,%eax
80102a33:	85 c0                	test   %eax,%eax
80102a35:	0f 84 a0 00 00 00    	je     80102adb <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102a3b:	c7 05 14 22 11 80 00 	movl   $0xfec00000,0x80112214
80102a42:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a45:	6a 01                	push   $0x1
80102a47:	e8 aa ff ff ff       	call   801029f6 <ioapicread>
80102a4c:	83 c4 04             	add    $0x4,%esp
80102a4f:	c1 e8 10             	shr    $0x10,%eax
80102a52:	25 ff 00 00 00       	and    $0xff,%eax
80102a57:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102a5a:	6a 00                	push   $0x0
80102a5c:	e8 95 ff ff ff       	call   801029f6 <ioapicread>
80102a61:	83 c4 04             	add    $0x4,%esp
80102a64:	c1 e8 18             	shr    $0x18,%eax
80102a67:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102a6a:	0f b6 05 40 23 11 80 	movzbl 0x80112340,%eax
80102a71:	0f b6 c0             	movzbl %al,%eax
80102a74:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80102a77:	74 10                	je     80102a89 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102a79:	83 ec 0c             	sub    $0xc,%esp
80102a7c:	68 80 87 10 80       	push   $0x80108780
80102a81:	e8 3e d9 ff ff       	call   801003c4 <cprintf>
80102a86:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102a90:	eb 3f                	jmp    80102ad1 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a95:	83 c0 20             	add    $0x20,%eax
80102a98:	0d 00 00 01 00       	or     $0x10000,%eax
80102a9d:	89 c2                	mov    %eax,%edx
80102a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aa2:	83 c0 08             	add    $0x8,%eax
80102aa5:	01 c0                	add    %eax,%eax
80102aa7:	83 ec 08             	sub    $0x8,%esp
80102aaa:	52                   	push   %edx
80102aab:	50                   	push   %eax
80102aac:	e8 5c ff ff ff       	call   80102a0d <ioapicwrite>
80102ab1:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ab7:	83 c0 08             	add    $0x8,%eax
80102aba:	01 c0                	add    %eax,%eax
80102abc:	83 c0 01             	add    $0x1,%eax
80102abf:	83 ec 08             	sub    $0x8,%esp
80102ac2:	6a 00                	push   $0x0
80102ac4:	50                   	push   %eax
80102ac5:	e8 43 ff ff ff       	call   80102a0d <ioapicwrite>
80102aca:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
80102acd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ad4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102ad7:	7e b9                	jle    80102a92 <ioapicinit+0x6a>
80102ad9:	eb 01                	jmp    80102adc <ioapicinit+0xb4>
    return;
80102adb:	90                   	nop
  }
}
80102adc:	c9                   	leave  
80102add:	c3                   	ret    

80102ade <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102ade:	55                   	push   %ebp
80102adf:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102ae1:	a1 44 23 11 80       	mov    0x80112344,%eax
80102ae6:	85 c0                	test   %eax,%eax
80102ae8:	74 39                	je     80102b23 <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102aea:	8b 45 08             	mov    0x8(%ebp),%eax
80102aed:	83 c0 20             	add    $0x20,%eax
80102af0:	89 c2                	mov    %eax,%edx
80102af2:	8b 45 08             	mov    0x8(%ebp),%eax
80102af5:	83 c0 08             	add    $0x8,%eax
80102af8:	01 c0                	add    %eax,%eax
80102afa:	52                   	push   %edx
80102afb:	50                   	push   %eax
80102afc:	e8 0c ff ff ff       	call   80102a0d <ioapicwrite>
80102b01:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b04:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b07:	c1 e0 18             	shl    $0x18,%eax
80102b0a:	89 c2                	mov    %eax,%edx
80102b0c:	8b 45 08             	mov    0x8(%ebp),%eax
80102b0f:	83 c0 08             	add    $0x8,%eax
80102b12:	01 c0                	add    %eax,%eax
80102b14:	83 c0 01             	add    $0x1,%eax
80102b17:	52                   	push   %edx
80102b18:	50                   	push   %eax
80102b19:	e8 ef fe ff ff       	call   80102a0d <ioapicwrite>
80102b1e:	83 c4 08             	add    $0x8,%esp
80102b21:	eb 01                	jmp    80102b24 <ioapicenable+0x46>
    return;
80102b23:	90                   	nop
}
80102b24:	c9                   	leave  
80102b25:	c3                   	ret    

80102b26 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102b26:	55                   	push   %ebp
80102b27:	89 e5                	mov    %esp,%ebp
80102b29:	8b 45 08             	mov    0x8(%ebp),%eax
80102b2c:	05 00 00 00 80       	add    $0x80000000,%eax
80102b31:	5d                   	pop    %ebp
80102b32:	c3                   	ret    

80102b33 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102b33:	55                   	push   %ebp
80102b34:	89 e5                	mov    %esp,%ebp
80102b36:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102b39:	83 ec 08             	sub    $0x8,%esp
80102b3c:	68 b2 87 10 80       	push   $0x801087b2
80102b41:	68 20 22 11 80       	push   $0x80112220
80102b46:	e8 d7 24 00 00       	call   80105022 <initlock>
80102b4b:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102b4e:	c7 05 54 22 11 80 00 	movl   $0x0,0x80112254
80102b55:	00 00 00 
  freerange(vstart, vend);
80102b58:	83 ec 08             	sub    $0x8,%esp
80102b5b:	ff 75 0c             	pushl  0xc(%ebp)
80102b5e:	ff 75 08             	pushl  0x8(%ebp)
80102b61:	e8 2a 00 00 00       	call   80102b90 <freerange>
80102b66:	83 c4 10             	add    $0x10,%esp
}
80102b69:	90                   	nop
80102b6a:	c9                   	leave  
80102b6b:	c3                   	ret    

80102b6c <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102b6c:	55                   	push   %ebp
80102b6d:	89 e5                	mov    %esp,%ebp
80102b6f:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102b72:	83 ec 08             	sub    $0x8,%esp
80102b75:	ff 75 0c             	pushl  0xc(%ebp)
80102b78:	ff 75 08             	pushl  0x8(%ebp)
80102b7b:	e8 10 00 00 00       	call   80102b90 <freerange>
80102b80:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102b83:	c7 05 54 22 11 80 01 	movl   $0x1,0x80112254
80102b8a:	00 00 00 
}
80102b8d:	90                   	nop
80102b8e:	c9                   	leave  
80102b8f:	c3                   	ret    

80102b90 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102b90:	55                   	push   %ebp
80102b91:	89 e5                	mov    %esp,%ebp
80102b93:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102b96:	8b 45 08             	mov    0x8(%ebp),%eax
80102b99:	05 ff 0f 00 00       	add    $0xfff,%eax
80102b9e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102ba3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ba6:	eb 15                	jmp    80102bbd <freerange+0x2d>
    kfree(p);
80102ba8:	83 ec 0c             	sub    $0xc,%esp
80102bab:	ff 75 f4             	pushl  -0xc(%ebp)
80102bae:	e8 1a 00 00 00       	call   80102bcd <kfree>
80102bb3:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bb6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bc0:	05 00 10 00 00       	add    $0x1000,%eax
80102bc5:	39 45 0c             	cmp    %eax,0xc(%ebp)
80102bc8:	73 de                	jae    80102ba8 <freerange+0x18>
}
80102bca:	90                   	nop
80102bcb:	c9                   	leave  
80102bcc:	c3                   	ret    

80102bcd <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102bcd:	55                   	push   %ebp
80102bce:	89 e5                	mov    %esp,%ebp
80102bd0:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102bd3:	8b 45 08             	mov    0x8(%ebp),%eax
80102bd6:	25 ff 0f 00 00       	and    $0xfff,%eax
80102bdb:	85 c0                	test   %eax,%eax
80102bdd:	75 1b                	jne    80102bfa <kfree+0x2d>
80102bdf:	81 7d 08 3c 51 11 80 	cmpl   $0x8011513c,0x8(%ebp)
80102be6:	72 12                	jb     80102bfa <kfree+0x2d>
80102be8:	ff 75 08             	pushl  0x8(%ebp)
80102beb:	e8 36 ff ff ff       	call   80102b26 <v2p>
80102bf0:	83 c4 04             	add    $0x4,%esp
80102bf3:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102bf8:	76 0d                	jbe    80102c07 <kfree+0x3a>
    panic("kfree");
80102bfa:	83 ec 0c             	sub    $0xc,%esp
80102bfd:	68 b7 87 10 80       	push   $0x801087b7
80102c02:	e8 60 d9 ff ff       	call   80100567 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102c07:	83 ec 04             	sub    $0x4,%esp
80102c0a:	68 00 10 00 00       	push   $0x1000
80102c0f:	6a 01                	push   $0x1
80102c11:	ff 75 08             	pushl  0x8(%ebp)
80102c14:	e8 8e 26 00 00       	call   801052a7 <memset>
80102c19:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102c1c:	a1 54 22 11 80       	mov    0x80112254,%eax
80102c21:	85 c0                	test   %eax,%eax
80102c23:	74 10                	je     80102c35 <kfree+0x68>
    acquire(&kmem.lock);
80102c25:	83 ec 0c             	sub    $0xc,%esp
80102c28:	68 20 22 11 80       	push   $0x80112220
80102c2d:	e8 12 24 00 00       	call   80105044 <acquire>
80102c32:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102c35:	8b 45 08             	mov    0x8(%ebp),%eax
80102c38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102c3b:	8b 15 58 22 11 80    	mov    0x80112258,%edx
80102c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c44:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c49:	a3 58 22 11 80       	mov    %eax,0x80112258
  if(kmem.use_lock)
80102c4e:	a1 54 22 11 80       	mov    0x80112254,%eax
80102c53:	85 c0                	test   %eax,%eax
80102c55:	74 10                	je     80102c67 <kfree+0x9a>
    release(&kmem.lock);
80102c57:	83 ec 0c             	sub    $0xc,%esp
80102c5a:	68 20 22 11 80       	push   $0x80112220
80102c5f:	e8 47 24 00 00       	call   801050ab <release>
80102c64:	83 c4 10             	add    $0x10,%esp
}
80102c67:	90                   	nop
80102c68:	c9                   	leave  
80102c69:	c3                   	ret    

80102c6a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102c6a:	55                   	push   %ebp
80102c6b:	89 e5                	mov    %esp,%ebp
80102c6d:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102c70:	a1 54 22 11 80       	mov    0x80112254,%eax
80102c75:	85 c0                	test   %eax,%eax
80102c77:	74 10                	je     80102c89 <kalloc+0x1f>
    acquire(&kmem.lock);
80102c79:	83 ec 0c             	sub    $0xc,%esp
80102c7c:	68 20 22 11 80       	push   $0x80112220
80102c81:	e8 be 23 00 00       	call   80105044 <acquire>
80102c86:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102c89:	a1 58 22 11 80       	mov    0x80112258,%eax
80102c8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102c91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102c95:	74 0a                	je     80102ca1 <kalloc+0x37>
    kmem.freelist = r->next;
80102c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c9a:	8b 00                	mov    (%eax),%eax
80102c9c:	a3 58 22 11 80       	mov    %eax,0x80112258
  if(kmem.use_lock)
80102ca1:	a1 54 22 11 80       	mov    0x80112254,%eax
80102ca6:	85 c0                	test   %eax,%eax
80102ca8:	74 10                	je     80102cba <kalloc+0x50>
    release(&kmem.lock);
80102caa:	83 ec 0c             	sub    $0xc,%esp
80102cad:	68 20 22 11 80       	push   $0x80112220
80102cb2:	e8 f4 23 00 00       	call   801050ab <release>
80102cb7:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102cbd:	c9                   	leave  
80102cbe:	c3                   	ret    

80102cbf <inb>:
{
80102cbf:	55                   	push   %ebp
80102cc0:	89 e5                	mov    %esp,%ebp
80102cc2:	83 ec 14             	sub    $0x14,%esp
80102cc5:	8b 45 08             	mov    0x8(%ebp),%eax
80102cc8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ccc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102cd0:	89 c2                	mov    %eax,%edx
80102cd2:	ec                   	in     (%dx),%al
80102cd3:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102cd6:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102cda:	c9                   	leave  
80102cdb:	c3                   	ret    

80102cdc <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102cdc:	55                   	push   %ebp
80102cdd:	89 e5                	mov    %esp,%ebp
80102cdf:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102ce2:	6a 64                	push   $0x64
80102ce4:	e8 d6 ff ff ff       	call   80102cbf <inb>
80102ce9:	83 c4 04             	add    $0x4,%esp
80102cec:	0f b6 c0             	movzbl %al,%eax
80102cef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cf5:	83 e0 01             	and    $0x1,%eax
80102cf8:	85 c0                	test   %eax,%eax
80102cfa:	75 0a                	jne    80102d06 <kbdgetc+0x2a>
    return -1;
80102cfc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d01:	e9 23 01 00 00       	jmp    80102e29 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102d06:	6a 60                	push   $0x60
80102d08:	e8 b2 ff ff ff       	call   80102cbf <inb>
80102d0d:	83 c4 04             	add    $0x4,%esp
80102d10:	0f b6 c0             	movzbl %al,%eax
80102d13:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102d16:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102d1d:	75 17                	jne    80102d36 <kbdgetc+0x5a>
    shift |= E0ESC;
80102d1f:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d24:	83 c8 40             	or     $0x40,%eax
80102d27:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102d2c:	b8 00 00 00 00       	mov    $0x0,%eax
80102d31:	e9 f3 00 00 00       	jmp    80102e29 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102d36:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d39:	25 80 00 00 00       	and    $0x80,%eax
80102d3e:	85 c0                	test   %eax,%eax
80102d40:	74 45                	je     80102d87 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102d42:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d47:	83 e0 40             	and    $0x40,%eax
80102d4a:	85 c0                	test   %eax,%eax
80102d4c:	75 08                	jne    80102d56 <kbdgetc+0x7a>
80102d4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d51:	83 e0 7f             	and    $0x7f,%eax
80102d54:	eb 03                	jmp    80102d59 <kbdgetc+0x7d>
80102d56:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d59:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102d5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d5f:	05 20 90 10 80       	add    $0x80109020,%eax
80102d64:	0f b6 00             	movzbl (%eax),%eax
80102d67:	83 c8 40             	or     $0x40,%eax
80102d6a:	0f b6 c0             	movzbl %al,%eax
80102d6d:	f7 d0                	not    %eax
80102d6f:	89 c2                	mov    %eax,%edx
80102d71:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d76:	21 d0                	and    %edx,%eax
80102d78:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102d7d:	b8 00 00 00 00       	mov    $0x0,%eax
80102d82:	e9 a2 00 00 00       	jmp    80102e29 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102d87:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d8c:	83 e0 40             	and    $0x40,%eax
80102d8f:	85 c0                	test   %eax,%eax
80102d91:	74 14                	je     80102da7 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102d93:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102d9a:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d9f:	83 e0 bf             	and    $0xffffffbf,%eax
80102da2:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  }

  shift |= shiftcode[data];
80102da7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102daa:	05 20 90 10 80       	add    $0x80109020,%eax
80102daf:	0f b6 00             	movzbl (%eax),%eax
80102db2:	0f b6 d0             	movzbl %al,%edx
80102db5:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102dba:	09 d0                	or     %edx,%eax
80102dbc:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  shift ^= togglecode[data];
80102dc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dc4:	05 20 91 10 80       	add    $0x80109120,%eax
80102dc9:	0f b6 00             	movzbl (%eax),%eax
80102dcc:	0f b6 d0             	movzbl %al,%edx
80102dcf:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102dd4:	31 d0                	xor    %edx,%eax
80102dd6:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102ddb:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102de0:	83 e0 03             	and    $0x3,%eax
80102de3:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102dea:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ded:	01 d0                	add    %edx,%eax
80102def:	0f b6 00             	movzbl (%eax),%eax
80102df2:	0f b6 c0             	movzbl %al,%eax
80102df5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102df8:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102dfd:	83 e0 08             	and    $0x8,%eax
80102e00:	85 c0                	test   %eax,%eax
80102e02:	74 22                	je     80102e26 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102e04:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102e08:	76 0c                	jbe    80102e16 <kbdgetc+0x13a>
80102e0a:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102e0e:	77 06                	ja     80102e16 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102e10:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102e14:	eb 10                	jmp    80102e26 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102e16:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102e1a:	76 0a                	jbe    80102e26 <kbdgetc+0x14a>
80102e1c:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102e20:	77 04                	ja     80102e26 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102e22:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102e26:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102e29:	c9                   	leave  
80102e2a:	c3                   	ret    

80102e2b <kbdintr>:

void
kbdintr(void)
{
80102e2b:	55                   	push   %ebp
80102e2c:	89 e5                	mov    %esp,%ebp
80102e2e:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102e31:	83 ec 0c             	sub    $0xc,%esp
80102e34:	68 dc 2c 10 80       	push   $0x80102cdc
80102e39:	e8 c4 d9 ff ff       	call   80100802 <consoleintr>
80102e3e:	83 c4 10             	add    $0x10,%esp
}
80102e41:	90                   	nop
80102e42:	c9                   	leave  
80102e43:	c3                   	ret    

80102e44 <inb>:
{
80102e44:	55                   	push   %ebp
80102e45:	89 e5                	mov    %esp,%ebp
80102e47:	83 ec 14             	sub    $0x14,%esp
80102e4a:	8b 45 08             	mov    0x8(%ebp),%eax
80102e4d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e51:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102e55:	89 c2                	mov    %eax,%edx
80102e57:	ec                   	in     (%dx),%al
80102e58:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102e5b:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102e5f:	c9                   	leave  
80102e60:	c3                   	ret    

80102e61 <outb>:
{
80102e61:	55                   	push   %ebp
80102e62:	89 e5                	mov    %esp,%ebp
80102e64:	83 ec 08             	sub    $0x8,%esp
80102e67:	8b 45 08             	mov    0x8(%ebp),%eax
80102e6a:	8b 55 0c             	mov    0xc(%ebp),%edx
80102e6d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102e71:	89 d0                	mov    %edx,%eax
80102e73:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e76:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102e7a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102e7e:	ee                   	out    %al,(%dx)
}
80102e7f:	90                   	nop
80102e80:	c9                   	leave  
80102e81:	c3                   	ret    

80102e82 <readeflags>:
{
80102e82:	55                   	push   %ebp
80102e83:	89 e5                	mov    %esp,%ebp
80102e85:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102e88:	9c                   	pushf  
80102e89:	58                   	pop    %eax
80102e8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102e8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102e90:	c9                   	leave  
80102e91:	c3                   	ret    

80102e92 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102e92:	55                   	push   %ebp
80102e93:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102e95:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102e9a:	8b 55 08             	mov    0x8(%ebp),%edx
80102e9d:	c1 e2 02             	shl    $0x2,%edx
80102ea0:	01 c2                	add    %eax,%edx
80102ea2:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ea5:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102ea7:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102eac:	83 c0 20             	add    $0x20,%eax
80102eaf:	8b 00                	mov    (%eax),%eax
}
80102eb1:	90                   	nop
80102eb2:	5d                   	pop    %ebp
80102eb3:	c3                   	ret    

80102eb4 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102eb4:	55                   	push   %ebp
80102eb5:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102eb7:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102ebc:	85 c0                	test   %eax,%eax
80102ebe:	0f 84 0c 01 00 00    	je     80102fd0 <lapicinit+0x11c>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102ec4:	68 3f 01 00 00       	push   $0x13f
80102ec9:	6a 3c                	push   $0x3c
80102ecb:	e8 c2 ff ff ff       	call   80102e92 <lapicw>
80102ed0:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102ed3:	6a 0b                	push   $0xb
80102ed5:	68 f8 00 00 00       	push   $0xf8
80102eda:	e8 b3 ff ff ff       	call   80102e92 <lapicw>
80102edf:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102ee2:	68 20 00 02 00       	push   $0x20020
80102ee7:	68 c8 00 00 00       	push   $0xc8
80102eec:	e8 a1 ff ff ff       	call   80102e92 <lapicw>
80102ef1:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80102ef4:	68 80 96 98 00       	push   $0x989680
80102ef9:	68 e0 00 00 00       	push   $0xe0
80102efe:	e8 8f ff ff ff       	call   80102e92 <lapicw>
80102f03:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102f06:	68 00 00 01 00       	push   $0x10000
80102f0b:	68 d4 00 00 00       	push   $0xd4
80102f10:	e8 7d ff ff ff       	call   80102e92 <lapicw>
80102f15:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102f18:	68 00 00 01 00       	push   $0x10000
80102f1d:	68 d8 00 00 00       	push   $0xd8
80102f22:	e8 6b ff ff ff       	call   80102e92 <lapicw>
80102f27:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102f2a:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102f2f:	83 c0 30             	add    $0x30,%eax
80102f32:	8b 00                	mov    (%eax),%eax
80102f34:	c1 e8 10             	shr    $0x10,%eax
80102f37:	25 fc 00 00 00       	and    $0xfc,%eax
80102f3c:	85 c0                	test   %eax,%eax
80102f3e:	74 12                	je     80102f52 <lapicinit+0x9e>
    lapicw(PCINT, MASKED);
80102f40:	68 00 00 01 00       	push   $0x10000
80102f45:	68 d0 00 00 00       	push   $0xd0
80102f4a:	e8 43 ff ff ff       	call   80102e92 <lapicw>
80102f4f:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102f52:	6a 33                	push   $0x33
80102f54:	68 dc 00 00 00       	push   $0xdc
80102f59:	e8 34 ff ff ff       	call   80102e92 <lapicw>
80102f5e:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102f61:	6a 00                	push   $0x0
80102f63:	68 a0 00 00 00       	push   $0xa0
80102f68:	e8 25 ff ff ff       	call   80102e92 <lapicw>
80102f6d:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102f70:	6a 00                	push   $0x0
80102f72:	68 a0 00 00 00       	push   $0xa0
80102f77:	e8 16 ff ff ff       	call   80102e92 <lapicw>
80102f7c:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102f7f:	6a 00                	push   $0x0
80102f81:	6a 2c                	push   $0x2c
80102f83:	e8 0a ff ff ff       	call   80102e92 <lapicw>
80102f88:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102f8b:	6a 00                	push   $0x0
80102f8d:	68 c4 00 00 00       	push   $0xc4
80102f92:	e8 fb fe ff ff       	call   80102e92 <lapicw>
80102f97:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102f9a:	68 00 85 08 00       	push   $0x88500
80102f9f:	68 c0 00 00 00       	push   $0xc0
80102fa4:	e8 e9 fe ff ff       	call   80102e92 <lapicw>
80102fa9:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102fac:	90                   	nop
80102fad:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102fb2:	05 00 03 00 00       	add    $0x300,%eax
80102fb7:	8b 00                	mov    (%eax),%eax
80102fb9:	25 00 10 00 00       	and    $0x1000,%eax
80102fbe:	85 c0                	test   %eax,%eax
80102fc0:	75 eb                	jne    80102fad <lapicinit+0xf9>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102fc2:	6a 00                	push   $0x0
80102fc4:	6a 20                	push   $0x20
80102fc6:	e8 c7 fe ff ff       	call   80102e92 <lapicw>
80102fcb:	83 c4 08             	add    $0x8,%esp
80102fce:	eb 01                	jmp    80102fd1 <lapicinit+0x11d>
    return;
80102fd0:	90                   	nop
}
80102fd1:	c9                   	leave  
80102fd2:	c3                   	ret    

80102fd3 <cpunum>:

int
cpunum(void)
{
80102fd3:	55                   	push   %ebp
80102fd4:	89 e5                	mov    %esp,%ebp
80102fd6:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102fd9:	e8 a4 fe ff ff       	call   80102e82 <readeflags>
80102fde:	25 00 02 00 00       	and    $0x200,%eax
80102fe3:	85 c0                	test   %eax,%eax
80102fe5:	74 26                	je     8010300d <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80102fe7:	a1 40 b6 10 80       	mov    0x8010b640,%eax
80102fec:	8d 50 01             	lea    0x1(%eax),%edx
80102fef:	89 15 40 b6 10 80    	mov    %edx,0x8010b640
80102ff5:	85 c0                	test   %eax,%eax
80102ff7:	75 14                	jne    8010300d <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80102ff9:	8b 45 04             	mov    0x4(%ebp),%eax
80102ffc:	83 ec 08             	sub    $0x8,%esp
80102fff:	50                   	push   %eax
80103000:	68 c0 87 10 80       	push   $0x801087c0
80103005:	e8 ba d3 ff ff       	call   801003c4 <cprintf>
8010300a:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
8010300d:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80103012:	85 c0                	test   %eax,%eax
80103014:	74 0f                	je     80103025 <cpunum+0x52>
    return lapic[ID]>>24;
80103016:	a1 5c 22 11 80       	mov    0x8011225c,%eax
8010301b:	83 c0 20             	add    $0x20,%eax
8010301e:	8b 00                	mov    (%eax),%eax
80103020:	c1 e8 18             	shr    $0x18,%eax
80103023:	eb 05                	jmp    8010302a <cpunum+0x57>
  return 0;
80103025:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010302a:	c9                   	leave  
8010302b:	c3                   	ret    

8010302c <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
8010302c:	55                   	push   %ebp
8010302d:	89 e5                	mov    %esp,%ebp
  if(lapic)
8010302f:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80103034:	85 c0                	test   %eax,%eax
80103036:	74 0c                	je     80103044 <lapiceoi+0x18>
    lapicw(EOI, 0);
80103038:	6a 00                	push   $0x0
8010303a:	6a 2c                	push   $0x2c
8010303c:	e8 51 fe ff ff       	call   80102e92 <lapicw>
80103041:	83 c4 08             	add    $0x8,%esp
}
80103044:	90                   	nop
80103045:	c9                   	leave  
80103046:	c3                   	ret    

80103047 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103047:	55                   	push   %ebp
80103048:	89 e5                	mov    %esp,%ebp
}
8010304a:	90                   	nop
8010304b:	5d                   	pop    %ebp
8010304c:	c3                   	ret    

8010304d <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
8010304d:	55                   	push   %ebp
8010304e:	89 e5                	mov    %esp,%ebp
80103050:	83 ec 14             	sub    $0x14,%esp
80103053:	8b 45 08             	mov    0x8(%ebp),%eax
80103056:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80103059:	6a 0f                	push   $0xf
8010305b:	6a 70                	push   $0x70
8010305d:	e8 ff fd ff ff       	call   80102e61 <outb>
80103062:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80103065:	6a 0a                	push   $0xa
80103067:	6a 71                	push   $0x71
80103069:	e8 f3 fd ff ff       	call   80102e61 <outb>
8010306e:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103071:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103078:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010307b:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103080:	8b 45 0c             	mov    0xc(%ebp),%eax
80103083:	c1 e8 04             	shr    $0x4,%eax
80103086:	89 c2                	mov    %eax,%edx
80103088:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010308b:	83 c0 02             	add    $0x2,%eax
8010308e:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103091:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103095:	c1 e0 18             	shl    $0x18,%eax
80103098:	50                   	push   %eax
80103099:	68 c4 00 00 00       	push   $0xc4
8010309e:	e8 ef fd ff ff       	call   80102e92 <lapicw>
801030a3:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801030a6:	68 00 c5 00 00       	push   $0xc500
801030ab:	68 c0 00 00 00       	push   $0xc0
801030b0:	e8 dd fd ff ff       	call   80102e92 <lapicw>
801030b5:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801030b8:	68 c8 00 00 00       	push   $0xc8
801030bd:	e8 85 ff ff ff       	call   80103047 <microdelay>
801030c2:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
801030c5:	68 00 85 00 00       	push   $0x8500
801030ca:	68 c0 00 00 00       	push   $0xc0
801030cf:	e8 be fd ff ff       	call   80102e92 <lapicw>
801030d4:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
801030d7:	6a 64                	push   $0x64
801030d9:	e8 69 ff ff ff       	call   80103047 <microdelay>
801030de:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801030e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801030e8:	eb 3d                	jmp    80103127 <lapicstartap+0xda>
    lapicw(ICRHI, apicid<<24);
801030ea:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801030ee:	c1 e0 18             	shl    $0x18,%eax
801030f1:	50                   	push   %eax
801030f2:	68 c4 00 00 00       	push   $0xc4
801030f7:	e8 96 fd ff ff       	call   80102e92 <lapicw>
801030fc:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
801030ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80103102:	c1 e8 0c             	shr    $0xc,%eax
80103105:	80 cc 06             	or     $0x6,%ah
80103108:	50                   	push   %eax
80103109:	68 c0 00 00 00       	push   $0xc0
8010310e:	e8 7f fd ff ff       	call   80102e92 <lapicw>
80103113:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80103116:	68 c8 00 00 00       	push   $0xc8
8010311b:	e8 27 ff ff ff       	call   80103047 <microdelay>
80103120:	83 c4 04             	add    $0x4,%esp
  for(i = 0; i < 2; i++){
80103123:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103127:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
8010312b:	7e bd                	jle    801030ea <lapicstartap+0x9d>
  }
}
8010312d:	90                   	nop
8010312e:	c9                   	leave  
8010312f:	c3                   	ret    

80103130 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103130:	55                   	push   %ebp
80103131:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80103133:	8b 45 08             	mov    0x8(%ebp),%eax
80103136:	0f b6 c0             	movzbl %al,%eax
80103139:	50                   	push   %eax
8010313a:	6a 70                	push   $0x70
8010313c:	e8 20 fd ff ff       	call   80102e61 <outb>
80103141:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103144:	68 c8 00 00 00       	push   $0xc8
80103149:	e8 f9 fe ff ff       	call   80103047 <microdelay>
8010314e:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
80103151:	6a 71                	push   $0x71
80103153:	e8 ec fc ff ff       	call   80102e44 <inb>
80103158:	83 c4 04             	add    $0x4,%esp
8010315b:	0f b6 c0             	movzbl %al,%eax
}
8010315e:	c9                   	leave  
8010315f:	c3                   	ret    

80103160 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80103163:	6a 00                	push   $0x0
80103165:	e8 c6 ff ff ff       	call   80103130 <cmos_read>
8010316a:	83 c4 04             	add    $0x4,%esp
8010316d:	89 c2                	mov    %eax,%edx
8010316f:	8b 45 08             	mov    0x8(%ebp),%eax
80103172:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
80103174:	6a 02                	push   $0x2
80103176:	e8 b5 ff ff ff       	call   80103130 <cmos_read>
8010317b:	83 c4 04             	add    $0x4,%esp
8010317e:	89 c2                	mov    %eax,%edx
80103180:	8b 45 08             	mov    0x8(%ebp),%eax
80103183:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
80103186:	6a 04                	push   $0x4
80103188:	e8 a3 ff ff ff       	call   80103130 <cmos_read>
8010318d:	83 c4 04             	add    $0x4,%esp
80103190:	89 c2                	mov    %eax,%edx
80103192:	8b 45 08             	mov    0x8(%ebp),%eax
80103195:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
80103198:	6a 07                	push   $0x7
8010319a:	e8 91 ff ff ff       	call   80103130 <cmos_read>
8010319f:	83 c4 04             	add    $0x4,%esp
801031a2:	89 c2                	mov    %eax,%edx
801031a4:	8b 45 08             	mov    0x8(%ebp),%eax
801031a7:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
801031aa:	6a 08                	push   $0x8
801031ac:	e8 7f ff ff ff       	call   80103130 <cmos_read>
801031b1:	83 c4 04             	add    $0x4,%esp
801031b4:	89 c2                	mov    %eax,%edx
801031b6:	8b 45 08             	mov    0x8(%ebp),%eax
801031b9:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
801031bc:	6a 09                	push   $0x9
801031be:	e8 6d ff ff ff       	call   80103130 <cmos_read>
801031c3:	83 c4 04             	add    $0x4,%esp
801031c6:	89 c2                	mov    %eax,%edx
801031c8:	8b 45 08             	mov    0x8(%ebp),%eax
801031cb:	89 50 14             	mov    %edx,0x14(%eax)
}
801031ce:	90                   	nop
801031cf:	c9                   	leave  
801031d0:	c3                   	ret    

801031d1 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801031d1:	55                   	push   %ebp
801031d2:	89 e5                	mov    %esp,%ebp
801031d4:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801031d7:	6a 0b                	push   $0xb
801031d9:	e8 52 ff ff ff       	call   80103130 <cmos_read>
801031de:	83 c4 04             	add    $0x4,%esp
801031e1:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801031e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031e7:	83 e0 04             	and    $0x4,%eax
801031ea:	85 c0                	test   %eax,%eax
801031ec:	0f 94 c0             	sete   %al
801031ef:	0f b6 c0             	movzbl %al,%eax
801031f2:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
801031f5:	8d 45 d8             	lea    -0x28(%ebp),%eax
801031f8:	50                   	push   %eax
801031f9:	e8 62 ff ff ff       	call   80103160 <fill_rtcdate>
801031fe:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
80103201:	6a 0a                	push   $0xa
80103203:	e8 28 ff ff ff       	call   80103130 <cmos_read>
80103208:	83 c4 04             	add    $0x4,%esp
8010320b:	25 80 00 00 00       	and    $0x80,%eax
80103210:	85 c0                	test   %eax,%eax
80103212:	75 27                	jne    8010323b <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
80103214:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103217:	50                   	push   %eax
80103218:	e8 43 ff ff ff       	call   80103160 <fill_rtcdate>
8010321d:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
80103220:	83 ec 04             	sub    $0x4,%esp
80103223:	6a 18                	push   $0x18
80103225:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103228:	50                   	push   %eax
80103229:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010322c:	50                   	push   %eax
8010322d:	e8 dc 20 00 00       	call   8010530e <memcmp>
80103232:	83 c4 10             	add    $0x10,%esp
80103235:	85 c0                	test   %eax,%eax
80103237:	74 05                	je     8010323e <cmostime+0x6d>
80103239:	eb ba                	jmp    801031f5 <cmostime+0x24>
        continue;
8010323b:	90                   	nop
    fill_rtcdate(&t1);
8010323c:	eb b7                	jmp    801031f5 <cmostime+0x24>
      break;
8010323e:	90                   	nop
  }

  // convert
  if (bcd) {
8010323f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103243:	0f 84 b4 00 00 00    	je     801032fd <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103249:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010324c:	c1 e8 04             	shr    $0x4,%eax
8010324f:	89 c2                	mov    %eax,%edx
80103251:	89 d0                	mov    %edx,%eax
80103253:	c1 e0 02             	shl    $0x2,%eax
80103256:	01 d0                	add    %edx,%eax
80103258:	01 c0                	add    %eax,%eax
8010325a:	89 c2                	mov    %eax,%edx
8010325c:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010325f:	83 e0 0f             	and    $0xf,%eax
80103262:	01 d0                	add    %edx,%eax
80103264:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103267:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010326a:	c1 e8 04             	shr    $0x4,%eax
8010326d:	89 c2                	mov    %eax,%edx
8010326f:	89 d0                	mov    %edx,%eax
80103271:	c1 e0 02             	shl    $0x2,%eax
80103274:	01 d0                	add    %edx,%eax
80103276:	01 c0                	add    %eax,%eax
80103278:	89 c2                	mov    %eax,%edx
8010327a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010327d:	83 e0 0f             	and    $0xf,%eax
80103280:	01 d0                	add    %edx,%eax
80103282:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80103285:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103288:	c1 e8 04             	shr    $0x4,%eax
8010328b:	89 c2                	mov    %eax,%edx
8010328d:	89 d0                	mov    %edx,%eax
8010328f:	c1 e0 02             	shl    $0x2,%eax
80103292:	01 d0                	add    %edx,%eax
80103294:	01 c0                	add    %eax,%eax
80103296:	89 c2                	mov    %eax,%edx
80103298:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010329b:	83 e0 0f             	and    $0xf,%eax
8010329e:	01 d0                	add    %edx,%eax
801032a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801032a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801032a6:	c1 e8 04             	shr    $0x4,%eax
801032a9:	89 c2                	mov    %eax,%edx
801032ab:	89 d0                	mov    %edx,%eax
801032ad:	c1 e0 02             	shl    $0x2,%eax
801032b0:	01 d0                	add    %edx,%eax
801032b2:	01 c0                	add    %eax,%eax
801032b4:	89 c2                	mov    %eax,%edx
801032b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801032b9:	83 e0 0f             	and    $0xf,%eax
801032bc:	01 d0                	add    %edx,%eax
801032be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801032c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801032c4:	c1 e8 04             	shr    $0x4,%eax
801032c7:	89 c2                	mov    %eax,%edx
801032c9:	89 d0                	mov    %edx,%eax
801032cb:	c1 e0 02             	shl    $0x2,%eax
801032ce:	01 d0                	add    %edx,%eax
801032d0:	01 c0                	add    %eax,%eax
801032d2:	89 c2                	mov    %eax,%edx
801032d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801032d7:	83 e0 0f             	and    $0xf,%eax
801032da:	01 d0                	add    %edx,%eax
801032dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801032df:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032e2:	c1 e8 04             	shr    $0x4,%eax
801032e5:	89 c2                	mov    %eax,%edx
801032e7:	89 d0                	mov    %edx,%eax
801032e9:	c1 e0 02             	shl    $0x2,%eax
801032ec:	01 d0                	add    %edx,%eax
801032ee:	01 c0                	add    %eax,%eax
801032f0:	89 c2                	mov    %eax,%edx
801032f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032f5:	83 e0 0f             	and    $0xf,%eax
801032f8:	01 d0                	add    %edx,%eax
801032fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
801032fd:	8b 45 08             	mov    0x8(%ebp),%eax
80103300:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103303:	89 10                	mov    %edx,(%eax)
80103305:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103308:	89 50 04             	mov    %edx,0x4(%eax)
8010330b:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010330e:	89 50 08             	mov    %edx,0x8(%eax)
80103311:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103314:	89 50 0c             	mov    %edx,0xc(%eax)
80103317:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010331a:	89 50 10             	mov    %edx,0x10(%eax)
8010331d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103320:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103323:	8b 45 08             	mov    0x8(%ebp),%eax
80103326:	8b 40 14             	mov    0x14(%eax),%eax
80103329:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
8010332f:	8b 45 08             	mov    0x8(%ebp),%eax
80103332:	89 50 14             	mov    %edx,0x14(%eax)
}
80103335:	90                   	nop
80103336:	c9                   	leave  
80103337:	c3                   	ret    

80103338 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103338:	55                   	push   %ebp
80103339:	89 e5                	mov    %esp,%ebp
8010333b:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010333e:	83 ec 08             	sub    $0x8,%esp
80103341:	68 ec 87 10 80       	push   $0x801087ec
80103346:	68 60 22 11 80       	push   $0x80112260
8010334b:	e8 d2 1c 00 00       	call   80105022 <initlock>
80103350:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80103353:	83 ec 08             	sub    $0x8,%esp
80103356:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103359:	50                   	push   %eax
8010335a:	ff 75 08             	pushl  0x8(%ebp)
8010335d:	e8 2d e0 ff ff       	call   8010138f <readsb>
80103362:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80103365:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103368:	a3 94 22 11 80       	mov    %eax,0x80112294
  log.size = sb.nlog;
8010336d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103370:	a3 98 22 11 80       	mov    %eax,0x80112298
  log.dev = dev;
80103375:	8b 45 08             	mov    0x8(%ebp),%eax
80103378:	a3 a4 22 11 80       	mov    %eax,0x801122a4
  recover_from_log();
8010337d:	e8 b2 01 00 00       	call   80103534 <recover_from_log>
}
80103382:	90                   	nop
80103383:	c9                   	leave  
80103384:	c3                   	ret    

80103385 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103385:	55                   	push   %ebp
80103386:	89 e5                	mov    %esp,%ebp
80103388:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010338b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103392:	e9 95 00 00 00       	jmp    8010342c <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103397:	8b 15 94 22 11 80    	mov    0x80112294,%edx
8010339d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033a0:	01 d0                	add    %edx,%eax
801033a2:	83 c0 01             	add    $0x1,%eax
801033a5:	89 c2                	mov    %eax,%edx
801033a7:	a1 a4 22 11 80       	mov    0x801122a4,%eax
801033ac:	83 ec 08             	sub    $0x8,%esp
801033af:	52                   	push   %edx
801033b0:	50                   	push   %eax
801033b1:	e8 00 ce ff ff       	call   801001b6 <bread>
801033b6:	83 c4 10             	add    $0x10,%esp
801033b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801033bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033bf:	83 c0 10             	add    $0x10,%eax
801033c2:	8b 04 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%eax
801033c9:	89 c2                	mov    %eax,%edx
801033cb:	a1 a4 22 11 80       	mov    0x801122a4,%eax
801033d0:	83 ec 08             	sub    $0x8,%esp
801033d3:	52                   	push   %edx
801033d4:	50                   	push   %eax
801033d5:	e8 dc cd ff ff       	call   801001b6 <bread>
801033da:	83 c4 10             	add    $0x10,%esp
801033dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801033e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033e3:	8d 50 18             	lea    0x18(%eax),%edx
801033e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033e9:	83 c0 18             	add    $0x18,%eax
801033ec:	83 ec 04             	sub    $0x4,%esp
801033ef:	68 00 02 00 00       	push   $0x200
801033f4:	52                   	push   %edx
801033f5:	50                   	push   %eax
801033f6:	e8 6b 1f 00 00       	call   80105366 <memmove>
801033fb:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
801033fe:	83 ec 0c             	sub    $0xc,%esp
80103401:	ff 75 ec             	pushl  -0x14(%ebp)
80103404:	e8 e6 cd ff ff       	call   801001ef <bwrite>
80103409:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
8010340c:	83 ec 0c             	sub    $0xc,%esp
8010340f:	ff 75 f0             	pushl  -0x10(%ebp)
80103412:	e8 17 ce ff ff       	call   8010022e <brelse>
80103417:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
8010341a:	83 ec 0c             	sub    $0xc,%esp
8010341d:	ff 75 ec             	pushl  -0x14(%ebp)
80103420:	e8 09 ce ff ff       	call   8010022e <brelse>
80103425:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80103428:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010342c:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103431:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103434:	0f 8c 5d ff ff ff    	jl     80103397 <install_trans+0x12>
  }
}
8010343a:	90                   	nop
8010343b:	c9                   	leave  
8010343c:	c3                   	ret    

8010343d <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010343d:	55                   	push   %ebp
8010343e:	89 e5                	mov    %esp,%ebp
80103440:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103443:	a1 94 22 11 80       	mov    0x80112294,%eax
80103448:	89 c2                	mov    %eax,%edx
8010344a:	a1 a4 22 11 80       	mov    0x801122a4,%eax
8010344f:	83 ec 08             	sub    $0x8,%esp
80103452:	52                   	push   %edx
80103453:	50                   	push   %eax
80103454:	e8 5d cd ff ff       	call   801001b6 <bread>
80103459:	83 c4 10             	add    $0x10,%esp
8010345c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
8010345f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103462:	83 c0 18             	add    $0x18,%eax
80103465:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103468:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010346b:	8b 00                	mov    (%eax),%eax
8010346d:	a3 a8 22 11 80       	mov    %eax,0x801122a8
  for (i = 0; i < log.lh.n; i++) {
80103472:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103479:	eb 1b                	jmp    80103496 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
8010347b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010347e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103481:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103485:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103488:	83 c2 10             	add    $0x10,%edx
8010348b:	89 04 95 6c 22 11 80 	mov    %eax,-0x7feedd94(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103492:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103496:	a1 a8 22 11 80       	mov    0x801122a8,%eax
8010349b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010349e:	7c db                	jl     8010347b <read_head+0x3e>
  }
  brelse(buf);
801034a0:	83 ec 0c             	sub    $0xc,%esp
801034a3:	ff 75 f0             	pushl  -0x10(%ebp)
801034a6:	e8 83 cd ff ff       	call   8010022e <brelse>
801034ab:	83 c4 10             	add    $0x10,%esp
}
801034ae:	90                   	nop
801034af:	c9                   	leave  
801034b0:	c3                   	ret    

801034b1 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801034b1:	55                   	push   %ebp
801034b2:	89 e5                	mov    %esp,%ebp
801034b4:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801034b7:	a1 94 22 11 80       	mov    0x80112294,%eax
801034bc:	89 c2                	mov    %eax,%edx
801034be:	a1 a4 22 11 80       	mov    0x801122a4,%eax
801034c3:	83 ec 08             	sub    $0x8,%esp
801034c6:	52                   	push   %edx
801034c7:	50                   	push   %eax
801034c8:	e8 e9 cc ff ff       	call   801001b6 <bread>
801034cd:	83 c4 10             	add    $0x10,%esp
801034d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801034d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034d6:	83 c0 18             	add    $0x18,%eax
801034d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801034dc:	8b 15 a8 22 11 80    	mov    0x801122a8,%edx
801034e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034e5:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801034e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801034ee:	eb 1b                	jmp    8010350b <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
801034f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034f3:	83 c0 10             	add    $0x10,%eax
801034f6:	8b 0c 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%ecx
801034fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103500:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103503:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103507:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010350b:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103510:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103513:	7c db                	jl     801034f0 <write_head+0x3f>
  }
  bwrite(buf);
80103515:	83 ec 0c             	sub    $0xc,%esp
80103518:	ff 75 f0             	pushl  -0x10(%ebp)
8010351b:	e8 cf cc ff ff       	call   801001ef <bwrite>
80103520:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
80103523:	83 ec 0c             	sub    $0xc,%esp
80103526:	ff 75 f0             	pushl  -0x10(%ebp)
80103529:	e8 00 cd ff ff       	call   8010022e <brelse>
8010352e:	83 c4 10             	add    $0x10,%esp
}
80103531:	90                   	nop
80103532:	c9                   	leave  
80103533:	c3                   	ret    

80103534 <recover_from_log>:

static void
recover_from_log(void)
{
80103534:	55                   	push   %ebp
80103535:	89 e5                	mov    %esp,%ebp
80103537:	83 ec 08             	sub    $0x8,%esp
  read_head();      
8010353a:	e8 fe fe ff ff       	call   8010343d <read_head>
  install_trans(); // if committed, copy from log to disk
8010353f:	e8 41 fe ff ff       	call   80103385 <install_trans>
  log.lh.n = 0;
80103544:	c7 05 a8 22 11 80 00 	movl   $0x0,0x801122a8
8010354b:	00 00 00 
  write_head(); // clear the log
8010354e:	e8 5e ff ff ff       	call   801034b1 <write_head>
}
80103553:	90                   	nop
80103554:	c9                   	leave  
80103555:	c3                   	ret    

80103556 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103556:	55                   	push   %ebp
80103557:	89 e5                	mov    %esp,%ebp
80103559:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
8010355c:	83 ec 0c             	sub    $0xc,%esp
8010355f:	68 60 22 11 80       	push   $0x80112260
80103564:	e8 db 1a 00 00       	call   80105044 <acquire>
80103569:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
8010356c:	a1 a0 22 11 80       	mov    0x801122a0,%eax
80103571:	85 c0                	test   %eax,%eax
80103573:	74 17                	je     8010358c <begin_op+0x36>
      sleep(&log, &log.lock);
80103575:	83 ec 08             	sub    $0x8,%esp
80103578:	68 60 22 11 80       	push   $0x80112260
8010357d:	68 60 22 11 80       	push   $0x80112260
80103582:	e8 c4 17 00 00       	call   80104d4b <sleep>
80103587:	83 c4 10             	add    $0x10,%esp
8010358a:	eb e0                	jmp    8010356c <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010358c:	8b 0d a8 22 11 80    	mov    0x801122a8,%ecx
80103592:	a1 9c 22 11 80       	mov    0x8011229c,%eax
80103597:	8d 50 01             	lea    0x1(%eax),%edx
8010359a:	89 d0                	mov    %edx,%eax
8010359c:	c1 e0 02             	shl    $0x2,%eax
8010359f:	01 d0                	add    %edx,%eax
801035a1:	01 c0                	add    %eax,%eax
801035a3:	01 c8                	add    %ecx,%eax
801035a5:	83 f8 1e             	cmp    $0x1e,%eax
801035a8:	7e 17                	jle    801035c1 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801035aa:	83 ec 08             	sub    $0x8,%esp
801035ad:	68 60 22 11 80       	push   $0x80112260
801035b2:	68 60 22 11 80       	push   $0x80112260
801035b7:	e8 8f 17 00 00       	call   80104d4b <sleep>
801035bc:	83 c4 10             	add    $0x10,%esp
801035bf:	eb ab                	jmp    8010356c <begin_op+0x16>
    } else {
      log.outstanding += 1;
801035c1:	a1 9c 22 11 80       	mov    0x8011229c,%eax
801035c6:	83 c0 01             	add    $0x1,%eax
801035c9:	a3 9c 22 11 80       	mov    %eax,0x8011229c
      release(&log.lock);
801035ce:	83 ec 0c             	sub    $0xc,%esp
801035d1:	68 60 22 11 80       	push   $0x80112260
801035d6:	e8 d0 1a 00 00       	call   801050ab <release>
801035db:	83 c4 10             	add    $0x10,%esp
      break;
801035de:	90                   	nop
    }
  }
}
801035df:	90                   	nop
801035e0:	c9                   	leave  
801035e1:	c3                   	ret    

801035e2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801035e2:	55                   	push   %ebp
801035e3:	89 e5                	mov    %esp,%ebp
801035e5:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
801035e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801035ef:	83 ec 0c             	sub    $0xc,%esp
801035f2:	68 60 22 11 80       	push   $0x80112260
801035f7:	e8 48 1a 00 00       	call   80105044 <acquire>
801035fc:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801035ff:	a1 9c 22 11 80       	mov    0x8011229c,%eax
80103604:	83 e8 01             	sub    $0x1,%eax
80103607:	a3 9c 22 11 80       	mov    %eax,0x8011229c
  if(log.committing)
8010360c:	a1 a0 22 11 80       	mov    0x801122a0,%eax
80103611:	85 c0                	test   %eax,%eax
80103613:	74 0d                	je     80103622 <end_op+0x40>
    panic("log.committing");
80103615:	83 ec 0c             	sub    $0xc,%esp
80103618:	68 f0 87 10 80       	push   $0x801087f0
8010361d:	e8 45 cf ff ff       	call   80100567 <panic>
  if(log.outstanding == 0){
80103622:	a1 9c 22 11 80       	mov    0x8011229c,%eax
80103627:	85 c0                	test   %eax,%eax
80103629:	75 13                	jne    8010363e <end_op+0x5c>
    do_commit = 1;
8010362b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103632:	c7 05 a0 22 11 80 01 	movl   $0x1,0x801122a0
80103639:	00 00 00 
8010363c:	eb 10                	jmp    8010364e <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
8010363e:	83 ec 0c             	sub    $0xc,%esp
80103641:	68 60 22 11 80       	push   $0x80112260
80103646:	e8 eb 17 00 00       	call   80104e36 <wakeup>
8010364b:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
8010364e:	83 ec 0c             	sub    $0xc,%esp
80103651:	68 60 22 11 80       	push   $0x80112260
80103656:	e8 50 1a 00 00       	call   801050ab <release>
8010365b:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
8010365e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103662:	74 3f                	je     801036a3 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103664:	e8 f5 00 00 00       	call   8010375e <commit>
    acquire(&log.lock);
80103669:	83 ec 0c             	sub    $0xc,%esp
8010366c:	68 60 22 11 80       	push   $0x80112260
80103671:	e8 ce 19 00 00       	call   80105044 <acquire>
80103676:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103679:	c7 05 a0 22 11 80 00 	movl   $0x0,0x801122a0
80103680:	00 00 00 
    wakeup(&log);
80103683:	83 ec 0c             	sub    $0xc,%esp
80103686:	68 60 22 11 80       	push   $0x80112260
8010368b:	e8 a6 17 00 00       	call   80104e36 <wakeup>
80103690:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103693:	83 ec 0c             	sub    $0xc,%esp
80103696:	68 60 22 11 80       	push   $0x80112260
8010369b:	e8 0b 1a 00 00       	call   801050ab <release>
801036a0:	83 c4 10             	add    $0x10,%esp
  }
}
801036a3:	90                   	nop
801036a4:	c9                   	leave  
801036a5:	c3                   	ret    

801036a6 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
801036a6:	55                   	push   %ebp
801036a7:	89 e5                	mov    %esp,%ebp
801036a9:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036b3:	e9 95 00 00 00       	jmp    8010374d <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801036b8:	8b 15 94 22 11 80    	mov    0x80112294,%edx
801036be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036c1:	01 d0                	add    %edx,%eax
801036c3:	83 c0 01             	add    $0x1,%eax
801036c6:	89 c2                	mov    %eax,%edx
801036c8:	a1 a4 22 11 80       	mov    0x801122a4,%eax
801036cd:	83 ec 08             	sub    $0x8,%esp
801036d0:	52                   	push   %edx
801036d1:	50                   	push   %eax
801036d2:	e8 df ca ff ff       	call   801001b6 <bread>
801036d7:	83 c4 10             	add    $0x10,%esp
801036da:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801036dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036e0:	83 c0 10             	add    $0x10,%eax
801036e3:	8b 04 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%eax
801036ea:	89 c2                	mov    %eax,%edx
801036ec:	a1 a4 22 11 80       	mov    0x801122a4,%eax
801036f1:	83 ec 08             	sub    $0x8,%esp
801036f4:	52                   	push   %edx
801036f5:	50                   	push   %eax
801036f6:	e8 bb ca ff ff       	call   801001b6 <bread>
801036fb:	83 c4 10             	add    $0x10,%esp
801036fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103701:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103704:	8d 50 18             	lea    0x18(%eax),%edx
80103707:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010370a:	83 c0 18             	add    $0x18,%eax
8010370d:	83 ec 04             	sub    $0x4,%esp
80103710:	68 00 02 00 00       	push   $0x200
80103715:	52                   	push   %edx
80103716:	50                   	push   %eax
80103717:	e8 4a 1c 00 00       	call   80105366 <memmove>
8010371c:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
8010371f:	83 ec 0c             	sub    $0xc,%esp
80103722:	ff 75 f0             	pushl  -0x10(%ebp)
80103725:	e8 c5 ca ff ff       	call   801001ef <bwrite>
8010372a:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
8010372d:	83 ec 0c             	sub    $0xc,%esp
80103730:	ff 75 ec             	pushl  -0x14(%ebp)
80103733:	e8 f6 ca ff ff       	call   8010022e <brelse>
80103738:	83 c4 10             	add    $0x10,%esp
    brelse(to);
8010373b:	83 ec 0c             	sub    $0xc,%esp
8010373e:	ff 75 f0             	pushl  -0x10(%ebp)
80103741:	e8 e8 ca ff ff       	call   8010022e <brelse>
80103746:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80103749:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010374d:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103752:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103755:	0f 8c 5d ff ff ff    	jl     801036b8 <write_log+0x12>
  }
}
8010375b:	90                   	nop
8010375c:	c9                   	leave  
8010375d:	c3                   	ret    

8010375e <commit>:

static void
commit()
{
8010375e:	55                   	push   %ebp
8010375f:	89 e5                	mov    %esp,%ebp
80103761:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103764:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103769:	85 c0                	test   %eax,%eax
8010376b:	7e 1e                	jle    8010378b <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
8010376d:	e8 34 ff ff ff       	call   801036a6 <write_log>
    write_head();    // Write header to disk -- the real commit
80103772:	e8 3a fd ff ff       	call   801034b1 <write_head>
    install_trans(); // Now install writes to home locations
80103777:	e8 09 fc ff ff       	call   80103385 <install_trans>
    log.lh.n = 0; 
8010377c:	c7 05 a8 22 11 80 00 	movl   $0x0,0x801122a8
80103783:	00 00 00 
    write_head();    // Erase the transaction from the log
80103786:	e8 26 fd ff ff       	call   801034b1 <write_head>
  }
}
8010378b:	90                   	nop
8010378c:	c9                   	leave  
8010378d:	c3                   	ret    

8010378e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010378e:	55                   	push   %ebp
8010378f:	89 e5                	mov    %esp,%ebp
80103791:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103794:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103799:	83 f8 1d             	cmp    $0x1d,%eax
8010379c:	7f 12                	jg     801037b0 <log_write+0x22>
8010379e:	a1 a8 22 11 80       	mov    0x801122a8,%eax
801037a3:	8b 15 98 22 11 80    	mov    0x80112298,%edx
801037a9:	83 ea 01             	sub    $0x1,%edx
801037ac:	39 d0                	cmp    %edx,%eax
801037ae:	7c 0d                	jl     801037bd <log_write+0x2f>
    panic("too big a transaction");
801037b0:	83 ec 0c             	sub    $0xc,%esp
801037b3:	68 ff 87 10 80       	push   $0x801087ff
801037b8:	e8 aa cd ff ff       	call   80100567 <panic>
  if (log.outstanding < 1)
801037bd:	a1 9c 22 11 80       	mov    0x8011229c,%eax
801037c2:	85 c0                	test   %eax,%eax
801037c4:	7f 0d                	jg     801037d3 <log_write+0x45>
    panic("log_write outside of trans");
801037c6:	83 ec 0c             	sub    $0xc,%esp
801037c9:	68 15 88 10 80       	push   $0x80108815
801037ce:	e8 94 cd ff ff       	call   80100567 <panic>

  acquire(&log.lock);
801037d3:	83 ec 0c             	sub    $0xc,%esp
801037d6:	68 60 22 11 80       	push   $0x80112260
801037db:	e8 64 18 00 00       	call   80105044 <acquire>
801037e0:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
801037e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801037ea:	eb 1d                	jmp    80103809 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801037ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037ef:	83 c0 10             	add    $0x10,%eax
801037f2:	8b 04 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%eax
801037f9:	89 c2                	mov    %eax,%edx
801037fb:	8b 45 08             	mov    0x8(%ebp),%eax
801037fe:	8b 40 08             	mov    0x8(%eax),%eax
80103801:	39 c2                	cmp    %eax,%edx
80103803:	74 10                	je     80103815 <log_write+0x87>
  for (i = 0; i < log.lh.n; i++) {
80103805:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103809:	a1 a8 22 11 80       	mov    0x801122a8,%eax
8010380e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103811:	7c d9                	jl     801037ec <log_write+0x5e>
80103813:	eb 01                	jmp    80103816 <log_write+0x88>
      break;
80103815:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
80103816:	8b 45 08             	mov    0x8(%ebp),%eax
80103819:	8b 40 08             	mov    0x8(%eax),%eax
8010381c:	89 c2                	mov    %eax,%edx
8010381e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103821:	83 c0 10             	add    $0x10,%eax
80103824:	89 14 85 6c 22 11 80 	mov    %edx,-0x7feedd94(,%eax,4)
  if (i == log.lh.n)
8010382b:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103830:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103833:	75 0d                	jne    80103842 <log_write+0xb4>
    log.lh.n++;
80103835:	a1 a8 22 11 80       	mov    0x801122a8,%eax
8010383a:	83 c0 01             	add    $0x1,%eax
8010383d:	a3 a8 22 11 80       	mov    %eax,0x801122a8
  b->flags |= B_DIRTY; // prevent eviction
80103842:	8b 45 08             	mov    0x8(%ebp),%eax
80103845:	8b 00                	mov    (%eax),%eax
80103847:	83 c8 04             	or     $0x4,%eax
8010384a:	89 c2                	mov    %eax,%edx
8010384c:	8b 45 08             	mov    0x8(%ebp),%eax
8010384f:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103851:	83 ec 0c             	sub    $0xc,%esp
80103854:	68 60 22 11 80       	push   $0x80112260
80103859:	e8 4d 18 00 00       	call   801050ab <release>
8010385e:	83 c4 10             	add    $0x10,%esp
}
80103861:	90                   	nop
80103862:	c9                   	leave  
80103863:	c3                   	ret    

80103864 <v2p>:
80103864:	55                   	push   %ebp
80103865:	89 e5                	mov    %esp,%ebp
80103867:	8b 45 08             	mov    0x8(%ebp),%eax
8010386a:	05 00 00 00 80       	add    $0x80000000,%eax
8010386f:	5d                   	pop    %ebp
80103870:	c3                   	ret    

80103871 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103871:	55                   	push   %ebp
80103872:	89 e5                	mov    %esp,%ebp
80103874:	8b 45 08             	mov    0x8(%ebp),%eax
80103877:	05 00 00 00 80       	add    $0x80000000,%eax
8010387c:	5d                   	pop    %ebp
8010387d:	c3                   	ret    

8010387e <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010387e:	55                   	push   %ebp
8010387f:	89 e5                	mov    %esp,%ebp
80103881:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103884:	8b 55 08             	mov    0x8(%ebp),%edx
80103887:	8b 45 0c             	mov    0xc(%ebp),%eax
8010388a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010388d:	f0 87 02             	lock xchg %eax,(%edx)
80103890:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103893:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103896:	c9                   	leave  
80103897:	c3                   	ret    

80103898 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103898:	8d 4c 24 04          	lea    0x4(%esp),%ecx
8010389c:	83 e4 f0             	and    $0xfffffff0,%esp
8010389f:	ff 71 fc             	pushl  -0x4(%ecx)
801038a2:	55                   	push   %ebp
801038a3:	89 e5                	mov    %esp,%ebp
801038a5:	51                   	push   %ecx
801038a6:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801038a9:	83 ec 08             	sub    $0x8,%esp
801038ac:	68 00 00 40 80       	push   $0x80400000
801038b1:	68 3c 51 11 80       	push   $0x8011513c
801038b6:	e8 78 f2 ff ff       	call   80102b33 <kinit1>
801038bb:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
801038be:	e8 3a 45 00 00       	call   80107dfd <kvmalloc>
  mpinit();        // collect info about this machine
801038c3:	e8 4d 04 00 00       	call   80103d15 <mpinit>
  lapicinit();
801038c8:	e8 e7 f5 ff ff       	call   80102eb4 <lapicinit>
  seginit();       // set up segments
801038cd:	e8 d4 3e 00 00       	call   801077a6 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801038d2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038d8:	0f b6 00             	movzbl (%eax),%eax
801038db:	0f b6 c0             	movzbl %al,%eax
801038de:	83 ec 08             	sub    $0x8,%esp
801038e1:	50                   	push   %eax
801038e2:	68 30 88 10 80       	push   $0x80108830
801038e7:	e8 d8 ca ff ff       	call   801003c4 <cprintf>
801038ec:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
801038ef:	e8 79 06 00 00       	call   80103f6d <picinit>
  ioapicinit();    // another interrupt controller
801038f4:	e8 2f f1 ff ff       	call   80102a28 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
801038f9:	e8 26 d2 ff ff       	call   80100b24 <consoleinit>
  uartinit();      // serial port
801038fe:	e8 ff 31 00 00       	call   80106b02 <uartinit>
  pinit();         // process table
80103903:	e8 6c 0b 00 00       	call   80104474 <pinit>
  tvinit();        // trap vectors
80103908:	e8 bd 2d 00 00       	call   801066ca <tvinit>
  binit();         // buffer cache
8010390d:	e8 22 c7 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103912:	e8 69 d6 ff ff       	call   80100f80 <fileinit>
  ideinit();       // disk
80103917:	e8 14 ed ff ff       	call   80102630 <ideinit>
  if(!ismp)
8010391c:	a1 44 23 11 80       	mov    0x80112344,%eax
80103921:	85 c0                	test   %eax,%eax
80103923:	75 05                	jne    8010392a <main+0x92>
    timerinit();   // uniprocessor timer
80103925:	e8 fd 2c 00 00       	call   80106627 <timerinit>
  startothers();   // start other processors
8010392a:	e8 8f 00 00 00       	call   801039be <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
8010392f:	83 ec 08             	sub    $0x8,%esp
80103932:	68 00 00 00 8e       	push   $0x8e000000
80103937:	68 00 00 40 80       	push   $0x80400000
8010393c:	e8 2b f2 ff ff       	call   80102b6c <kinit2>
80103941:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103944:	e8 4f 0c 00 00       	call   80104598 <userinit>
  // Finish setting up this processor in mpmain.
  cprintf("CS350 proj0 printing in kernel space\n");
80103949:	83 ec 0c             	sub    $0xc,%esp
8010394c:	68 48 88 10 80       	push   $0x80108848
80103951:	e8 6e ca ff ff       	call   801003c4 <cprintf>
80103956:	83 c4 10             	add    $0x10,%esp
  mpmain();
80103959:	e8 1a 00 00 00       	call   80103978 <mpmain>

8010395e <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
8010395e:	55                   	push   %ebp
8010395f:	89 e5                	mov    %esp,%ebp
80103961:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103964:	e8 ac 44 00 00       	call   80107e15 <switchkvm>
  seginit();
80103969:	e8 38 3e 00 00       	call   801077a6 <seginit>
  lapicinit();
8010396e:	e8 41 f5 ff ff       	call   80102eb4 <lapicinit>
  mpmain();
80103973:	e8 00 00 00 00       	call   80103978 <mpmain>

80103978 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103978:	55                   	push   %ebp
80103979:	89 e5                	mov    %esp,%ebp
8010397b:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
8010397e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103984:	0f b6 00             	movzbl (%eax),%eax
80103987:	0f b6 c0             	movzbl %al,%eax
8010398a:	83 ec 08             	sub    $0x8,%esp
8010398d:	50                   	push   %eax
8010398e:	68 6e 88 10 80       	push   $0x8010886e
80103993:	e8 2c ca ff ff       	call   801003c4 <cprintf>
80103998:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
8010399b:	e8 a0 2e 00 00       	call   80106840 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801039a0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801039a6:	05 a8 00 00 00       	add    $0xa8,%eax
801039ab:	83 ec 08             	sub    $0x8,%esp
801039ae:	6a 01                	push   $0x1
801039b0:	50                   	push   %eax
801039b1:	e8 c8 fe ff ff       	call   8010387e <xchg>
801039b6:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
801039b9:	e8 87 11 00 00       	call   80104b45 <scheduler>

801039be <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801039be:	55                   	push   %ebp
801039bf:	89 e5                	mov    %esp,%ebp
801039c1:	83 ec 18             	sub    $0x18,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801039c4:	68 00 70 00 00       	push   $0x7000
801039c9:	e8 a3 fe ff ff       	call   80103871 <p2v>
801039ce:	83 c4 04             	add    $0x4,%esp
801039d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801039d4:	b8 8a 00 00 00       	mov    $0x8a,%eax
801039d9:	83 ec 04             	sub    $0x4,%esp
801039dc:	50                   	push   %eax
801039dd:	68 0c b5 10 80       	push   $0x8010b50c
801039e2:	ff 75 f0             	pushl  -0x10(%ebp)
801039e5:	e8 7c 19 00 00       	call   80105366 <memmove>
801039ea:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
801039ed:	c7 45 f4 60 23 11 80 	movl   $0x80112360,-0xc(%ebp)
801039f4:	e9 92 00 00 00       	jmp    80103a8b <startothers+0xcd>
    if(c == cpus+cpunum())  // We've started already.
801039f9:	e8 d5 f5 ff ff       	call   80102fd3 <cpunum>
801039fe:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a04:	05 60 23 11 80       	add    $0x80112360,%eax
80103a09:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103a0c:	74 75                	je     80103a83 <startothers+0xc5>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103a0e:	e8 57 f2 ff ff       	call   80102c6a <kalloc>
80103a13:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a19:	83 e8 04             	sub    $0x4,%eax
80103a1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103a1f:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103a25:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a2a:	83 e8 08             	sub    $0x8,%eax
80103a2d:	c7 00 5e 39 10 80    	movl   $0x8010395e,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103a33:	83 ec 0c             	sub    $0xc,%esp
80103a36:	68 00 a0 10 80       	push   $0x8010a000
80103a3b:	e8 24 fe ff ff       	call   80103864 <v2p>
80103a40:	83 c4 10             	add    $0x10,%esp
80103a43:	89 c2                	mov    %eax,%edx
80103a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a48:	83 e8 0c             	sub    $0xc,%eax
80103a4b:	89 10                	mov    %edx,(%eax)

    lapicstartap(c->id, v2p(code));
80103a4d:	83 ec 0c             	sub    $0xc,%esp
80103a50:	ff 75 f0             	pushl  -0x10(%ebp)
80103a53:	e8 0c fe ff ff       	call   80103864 <v2p>
80103a58:	83 c4 10             	add    $0x10,%esp
80103a5b:	89 c2                	mov    %eax,%edx
80103a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a60:	0f b6 00             	movzbl (%eax),%eax
80103a63:	0f b6 c0             	movzbl %al,%eax
80103a66:	83 ec 08             	sub    $0x8,%esp
80103a69:	52                   	push   %edx
80103a6a:	50                   	push   %eax
80103a6b:	e8 dd f5 ff ff       	call   8010304d <lapicstartap>
80103a70:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103a73:	90                   	nop
80103a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a77:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103a7d:	85 c0                	test   %eax,%eax
80103a7f:	74 f3                	je     80103a74 <startothers+0xb6>
80103a81:	eb 01                	jmp    80103a84 <startothers+0xc6>
      continue;
80103a83:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
80103a84:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103a8b:	a1 40 29 11 80       	mov    0x80112940,%eax
80103a90:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a96:	05 60 23 11 80       	add    $0x80112360,%eax
80103a9b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103a9e:	0f 82 55 ff ff ff    	jb     801039f9 <startothers+0x3b>
      ;
  }
}
80103aa4:	90                   	nop
80103aa5:	c9                   	leave  
80103aa6:	c3                   	ret    

80103aa7 <p2v>:
80103aa7:	55                   	push   %ebp
80103aa8:	89 e5                	mov    %esp,%ebp
80103aaa:	8b 45 08             	mov    0x8(%ebp),%eax
80103aad:	05 00 00 00 80       	add    $0x80000000,%eax
80103ab2:	5d                   	pop    %ebp
80103ab3:	c3                   	ret    

80103ab4 <inb>:
{
80103ab4:	55                   	push   %ebp
80103ab5:	89 e5                	mov    %esp,%ebp
80103ab7:	83 ec 14             	sub    $0x14,%esp
80103aba:	8b 45 08             	mov    0x8(%ebp),%eax
80103abd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103ac1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103ac5:	89 c2                	mov    %eax,%edx
80103ac7:	ec                   	in     (%dx),%al
80103ac8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103acb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103acf:	c9                   	leave  
80103ad0:	c3                   	ret    

80103ad1 <outb>:
{
80103ad1:	55                   	push   %ebp
80103ad2:	89 e5                	mov    %esp,%ebp
80103ad4:	83 ec 08             	sub    $0x8,%esp
80103ad7:	8b 45 08             	mov    0x8(%ebp),%eax
80103ada:	8b 55 0c             	mov    0xc(%ebp),%edx
80103add:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103ae1:	89 d0                	mov    %edx,%eax
80103ae3:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ae6:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103aea:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103aee:	ee                   	out    %al,(%dx)
}
80103aef:	90                   	nop
80103af0:	c9                   	leave  
80103af1:	c3                   	ret    

80103af2 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103af2:	55                   	push   %ebp
80103af3:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103af5:	a1 44 b6 10 80       	mov    0x8010b644,%eax
80103afa:	2d 60 23 11 80       	sub    $0x80112360,%eax
80103aff:	c1 f8 02             	sar    $0x2,%eax
80103b02:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103b08:	5d                   	pop    %ebp
80103b09:	c3                   	ret    

80103b0a <sum>:

static uchar
sum(uchar *addr, int len)
{
80103b0a:	55                   	push   %ebp
80103b0b:	89 e5                	mov    %esp,%ebp
80103b0d:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103b10:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103b17:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103b1e:	eb 15                	jmp    80103b35 <sum+0x2b>
    sum += addr[i];
80103b20:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103b23:	8b 45 08             	mov    0x8(%ebp),%eax
80103b26:	01 d0                	add    %edx,%eax
80103b28:	0f b6 00             	movzbl (%eax),%eax
80103b2b:	0f b6 c0             	movzbl %al,%eax
80103b2e:	01 45 f8             	add    %eax,-0x8(%ebp)
  for(i=0; i<len; i++)
80103b31:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103b35:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103b38:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103b3b:	7c e3                	jl     80103b20 <sum+0x16>
  return sum;
80103b3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103b40:	c9                   	leave  
80103b41:	c3                   	ret    

80103b42 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103b42:	55                   	push   %ebp
80103b43:	89 e5                	mov    %esp,%ebp
80103b45:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103b48:	ff 75 08             	pushl  0x8(%ebp)
80103b4b:	e8 57 ff ff ff       	call   80103aa7 <p2v>
80103b50:	83 c4 04             	add    $0x4,%esp
80103b53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103b56:	8b 55 0c             	mov    0xc(%ebp),%edx
80103b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b5c:	01 d0                	add    %edx,%eax
80103b5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b64:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b67:	eb 36                	jmp    80103b9f <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103b69:	83 ec 04             	sub    $0x4,%esp
80103b6c:	6a 04                	push   $0x4
80103b6e:	68 80 88 10 80       	push   $0x80108880
80103b73:	ff 75 f4             	pushl  -0xc(%ebp)
80103b76:	e8 93 17 00 00       	call   8010530e <memcmp>
80103b7b:	83 c4 10             	add    $0x10,%esp
80103b7e:	85 c0                	test   %eax,%eax
80103b80:	75 19                	jne    80103b9b <mpsearch1+0x59>
80103b82:	83 ec 08             	sub    $0x8,%esp
80103b85:	6a 10                	push   $0x10
80103b87:	ff 75 f4             	pushl  -0xc(%ebp)
80103b8a:	e8 7b ff ff ff       	call   80103b0a <sum>
80103b8f:	83 c4 10             	add    $0x10,%esp
80103b92:	84 c0                	test   %al,%al
80103b94:	75 05                	jne    80103b9b <mpsearch1+0x59>
      return (struct mp*)p;
80103b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b99:	eb 11                	jmp    80103bac <mpsearch1+0x6a>
  for(p = addr; p < e; p += sizeof(struct mp))
80103b9b:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ba2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103ba5:	72 c2                	jb     80103b69 <mpsearch1+0x27>
  return 0;
80103ba7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103bac:	c9                   	leave  
80103bad:	c3                   	ret    

80103bae <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103bae:	55                   	push   %ebp
80103baf:	89 e5                	mov    %esp,%ebp
80103bb1:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103bb4:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bbe:	83 c0 0f             	add    $0xf,%eax
80103bc1:	0f b6 00             	movzbl (%eax),%eax
80103bc4:	0f b6 c0             	movzbl %al,%eax
80103bc7:	c1 e0 08             	shl    $0x8,%eax
80103bca:	89 c2                	mov    %eax,%edx
80103bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bcf:	83 c0 0e             	add    $0xe,%eax
80103bd2:	0f b6 00             	movzbl (%eax),%eax
80103bd5:	0f b6 c0             	movzbl %al,%eax
80103bd8:	09 d0                	or     %edx,%eax
80103bda:	c1 e0 04             	shl    $0x4,%eax
80103bdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103be0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103be4:	74 21                	je     80103c07 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103be6:	83 ec 08             	sub    $0x8,%esp
80103be9:	68 00 04 00 00       	push   $0x400
80103bee:	ff 75 f0             	pushl  -0x10(%ebp)
80103bf1:	e8 4c ff ff ff       	call   80103b42 <mpsearch1>
80103bf6:	83 c4 10             	add    $0x10,%esp
80103bf9:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103bfc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c00:	74 51                	je     80103c53 <mpsearch+0xa5>
      return mp;
80103c02:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c05:	eb 61                	jmp    80103c68 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c0a:	83 c0 14             	add    $0x14,%eax
80103c0d:	0f b6 00             	movzbl (%eax),%eax
80103c10:	0f b6 c0             	movzbl %al,%eax
80103c13:	c1 e0 08             	shl    $0x8,%eax
80103c16:	89 c2                	mov    %eax,%edx
80103c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c1b:	83 c0 13             	add    $0x13,%eax
80103c1e:	0f b6 00             	movzbl (%eax),%eax
80103c21:	0f b6 c0             	movzbl %al,%eax
80103c24:	09 d0                	or     %edx,%eax
80103c26:	c1 e0 0a             	shl    $0xa,%eax
80103c29:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c2f:	2d 00 04 00 00       	sub    $0x400,%eax
80103c34:	83 ec 08             	sub    $0x8,%esp
80103c37:	68 00 04 00 00       	push   $0x400
80103c3c:	50                   	push   %eax
80103c3d:	e8 00 ff ff ff       	call   80103b42 <mpsearch1>
80103c42:	83 c4 10             	add    $0x10,%esp
80103c45:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c48:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c4c:	74 05                	je     80103c53 <mpsearch+0xa5>
      return mp;
80103c4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c51:	eb 15                	jmp    80103c68 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103c53:	83 ec 08             	sub    $0x8,%esp
80103c56:	68 00 00 01 00       	push   $0x10000
80103c5b:	68 00 00 0f 00       	push   $0xf0000
80103c60:	e8 dd fe ff ff       	call   80103b42 <mpsearch1>
80103c65:	83 c4 10             	add    $0x10,%esp
}
80103c68:	c9                   	leave  
80103c69:	c3                   	ret    

80103c6a <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103c6a:	55                   	push   %ebp
80103c6b:	89 e5                	mov    %esp,%ebp
80103c6d:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103c70:	e8 39 ff ff ff       	call   80103bae <mpsearch>
80103c75:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c7c:	74 0a                	je     80103c88 <mpconfig+0x1e>
80103c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c81:	8b 40 04             	mov    0x4(%eax),%eax
80103c84:	85 c0                	test   %eax,%eax
80103c86:	75 0a                	jne    80103c92 <mpconfig+0x28>
    return 0;
80103c88:	b8 00 00 00 00       	mov    $0x0,%eax
80103c8d:	e9 81 00 00 00       	jmp    80103d13 <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c95:	8b 40 04             	mov    0x4(%eax),%eax
80103c98:	83 ec 0c             	sub    $0xc,%esp
80103c9b:	50                   	push   %eax
80103c9c:	e8 06 fe ff ff       	call   80103aa7 <p2v>
80103ca1:	83 c4 10             	add    $0x10,%esp
80103ca4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103ca7:	83 ec 04             	sub    $0x4,%esp
80103caa:	6a 04                	push   $0x4
80103cac:	68 85 88 10 80       	push   $0x80108885
80103cb1:	ff 75 f0             	pushl  -0x10(%ebp)
80103cb4:	e8 55 16 00 00       	call   8010530e <memcmp>
80103cb9:	83 c4 10             	add    $0x10,%esp
80103cbc:	85 c0                	test   %eax,%eax
80103cbe:	74 07                	je     80103cc7 <mpconfig+0x5d>
    return 0;
80103cc0:	b8 00 00 00 00       	mov    $0x0,%eax
80103cc5:	eb 4c                	jmp    80103d13 <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103cc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cca:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103cce:	3c 01                	cmp    $0x1,%al
80103cd0:	74 12                	je     80103ce4 <mpconfig+0x7a>
80103cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cd5:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103cd9:	3c 04                	cmp    $0x4,%al
80103cdb:	74 07                	je     80103ce4 <mpconfig+0x7a>
    return 0;
80103cdd:	b8 00 00 00 00       	mov    $0x0,%eax
80103ce2:	eb 2f                	jmp    80103d13 <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ce7:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103ceb:	0f b7 c0             	movzwl %ax,%eax
80103cee:	83 ec 08             	sub    $0x8,%esp
80103cf1:	50                   	push   %eax
80103cf2:	ff 75 f0             	pushl  -0x10(%ebp)
80103cf5:	e8 10 fe ff ff       	call   80103b0a <sum>
80103cfa:	83 c4 10             	add    $0x10,%esp
80103cfd:	84 c0                	test   %al,%al
80103cff:	74 07                	je     80103d08 <mpconfig+0x9e>
    return 0;
80103d01:	b8 00 00 00 00       	mov    $0x0,%eax
80103d06:	eb 0b                	jmp    80103d13 <mpconfig+0xa9>
  *pmp = mp;
80103d08:	8b 45 08             	mov    0x8(%ebp),%eax
80103d0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d0e:	89 10                	mov    %edx,(%eax)
  return conf;
80103d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103d13:	c9                   	leave  
80103d14:	c3                   	ret    

80103d15 <mpinit>:

void
mpinit(void)
{
80103d15:	55                   	push   %ebp
80103d16:	89 e5                	mov    %esp,%ebp
80103d18:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103d1b:	c7 05 44 b6 10 80 60 	movl   $0x80112360,0x8010b644
80103d22:	23 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103d25:	83 ec 0c             	sub    $0xc,%esp
80103d28:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103d2b:	50                   	push   %eax
80103d2c:	e8 39 ff ff ff       	call   80103c6a <mpconfig>
80103d31:	83 c4 10             	add    $0x10,%esp
80103d34:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103d37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103d3b:	0f 84 96 01 00 00    	je     80103ed7 <mpinit+0x1c2>
    return;
  ismp = 1;
80103d41:	c7 05 44 23 11 80 01 	movl   $0x1,0x80112344
80103d48:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d4e:	8b 40 24             	mov    0x24(%eax),%eax
80103d51:	a3 5c 22 11 80       	mov    %eax,0x8011225c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d59:	83 c0 2c             	add    $0x2c,%eax
80103d5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d62:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103d66:	0f b7 d0             	movzwl %ax,%edx
80103d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d6c:	01 d0                	add    %edx,%eax
80103d6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d71:	e9 f2 00 00 00       	jmp    80103e68 <mpinit+0x153>
    switch(*p){
80103d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d79:	0f b6 00             	movzbl (%eax),%eax
80103d7c:	0f b6 c0             	movzbl %al,%eax
80103d7f:	83 f8 04             	cmp    $0x4,%eax
80103d82:	0f 87 bc 00 00 00    	ja     80103e44 <mpinit+0x12f>
80103d88:	8b 04 85 c8 88 10 80 	mov    -0x7fef7738(,%eax,4),%eax
80103d8f:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d94:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103d97:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d9a:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d9e:	0f b6 d0             	movzbl %al,%edx
80103da1:	a1 40 29 11 80       	mov    0x80112940,%eax
80103da6:	39 c2                	cmp    %eax,%edx
80103da8:	74 2b                	je     80103dd5 <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103daa:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103dad:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103db1:	0f b6 d0             	movzbl %al,%edx
80103db4:	a1 40 29 11 80       	mov    0x80112940,%eax
80103db9:	83 ec 04             	sub    $0x4,%esp
80103dbc:	52                   	push   %edx
80103dbd:	50                   	push   %eax
80103dbe:	68 8a 88 10 80       	push   $0x8010888a
80103dc3:	e8 fc c5 ff ff       	call   801003c4 <cprintf>
80103dc8:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103dcb:	c7 05 44 23 11 80 00 	movl   $0x0,0x80112344
80103dd2:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103dd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103dd8:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103ddc:	0f b6 c0             	movzbl %al,%eax
80103ddf:	83 e0 02             	and    $0x2,%eax
80103de2:	85 c0                	test   %eax,%eax
80103de4:	74 15                	je     80103dfb <mpinit+0xe6>
        bcpu = &cpus[ncpu];
80103de6:	a1 40 29 11 80       	mov    0x80112940,%eax
80103deb:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103df1:	05 60 23 11 80       	add    $0x80112360,%eax
80103df6:	a3 44 b6 10 80       	mov    %eax,0x8010b644
      cpus[ncpu].id = ncpu;
80103dfb:	8b 15 40 29 11 80    	mov    0x80112940,%edx
80103e01:	a1 40 29 11 80       	mov    0x80112940,%eax
80103e06:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103e0c:	05 60 23 11 80       	add    $0x80112360,%eax
80103e11:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103e13:	a1 40 29 11 80       	mov    0x80112940,%eax
80103e18:	83 c0 01             	add    $0x1,%eax
80103e1b:	a3 40 29 11 80       	mov    %eax,0x80112940
      p += sizeof(struct mpproc);
80103e20:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103e24:	eb 42                	jmp    80103e68 <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103e2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103e2f:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e33:	a2 40 23 11 80       	mov    %al,0x80112340
      p += sizeof(struct mpioapic);
80103e38:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103e3c:	eb 2a                	jmp    80103e68 <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103e3e:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103e42:	eb 24                	jmp    80103e68 <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e47:	0f b6 00             	movzbl (%eax),%eax
80103e4a:	0f b6 c0             	movzbl %al,%eax
80103e4d:	83 ec 08             	sub    $0x8,%esp
80103e50:	50                   	push   %eax
80103e51:	68 a8 88 10 80       	push   $0x801088a8
80103e56:	e8 69 c5 ff ff       	call   801003c4 <cprintf>
80103e5b:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103e5e:	c7 05 44 23 11 80 00 	movl   $0x0,0x80112344
80103e65:	00 00 00 
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e6b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103e6e:	0f 82 02 ff ff ff    	jb     80103d76 <mpinit+0x61>
    }
  }
  if(!ismp){
80103e74:	a1 44 23 11 80       	mov    0x80112344,%eax
80103e79:	85 c0                	test   %eax,%eax
80103e7b:	75 1d                	jne    80103e9a <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103e7d:	c7 05 40 29 11 80 01 	movl   $0x1,0x80112940
80103e84:	00 00 00 
    lapic = 0;
80103e87:	c7 05 5c 22 11 80 00 	movl   $0x0,0x8011225c
80103e8e:	00 00 00 
    ioapicid = 0;
80103e91:	c6 05 40 23 11 80 00 	movb   $0x0,0x80112340
    return;
80103e98:	eb 3e                	jmp    80103ed8 <mpinit+0x1c3>
  }

  if(mp->imcrp){
80103e9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e9d:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103ea1:	84 c0                	test   %al,%al
80103ea3:	74 33                	je     80103ed8 <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103ea5:	83 ec 08             	sub    $0x8,%esp
80103ea8:	6a 70                	push   $0x70
80103eaa:	6a 22                	push   $0x22
80103eac:	e8 20 fc ff ff       	call   80103ad1 <outb>
80103eb1:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103eb4:	83 ec 0c             	sub    $0xc,%esp
80103eb7:	6a 23                	push   $0x23
80103eb9:	e8 f6 fb ff ff       	call   80103ab4 <inb>
80103ebe:	83 c4 10             	add    $0x10,%esp
80103ec1:	83 c8 01             	or     $0x1,%eax
80103ec4:	0f b6 c0             	movzbl %al,%eax
80103ec7:	83 ec 08             	sub    $0x8,%esp
80103eca:	50                   	push   %eax
80103ecb:	6a 23                	push   $0x23
80103ecd:	e8 ff fb ff ff       	call   80103ad1 <outb>
80103ed2:	83 c4 10             	add    $0x10,%esp
80103ed5:	eb 01                	jmp    80103ed8 <mpinit+0x1c3>
    return;
80103ed7:	90                   	nop
  }
}
80103ed8:	c9                   	leave  
80103ed9:	c3                   	ret    

80103eda <outb>:
{
80103eda:	55                   	push   %ebp
80103edb:	89 e5                	mov    %esp,%ebp
80103edd:	83 ec 08             	sub    $0x8,%esp
80103ee0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ee3:	8b 55 0c             	mov    0xc(%ebp),%edx
80103ee6:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103eea:	89 d0                	mov    %edx,%eax
80103eec:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103eef:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103ef3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103ef7:	ee                   	out    %al,(%dx)
}
80103ef8:	90                   	nop
80103ef9:	c9                   	leave  
80103efa:	c3                   	ret    

80103efb <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103efb:	55                   	push   %ebp
80103efc:	89 e5                	mov    %esp,%ebp
80103efe:	83 ec 04             	sub    $0x4,%esp
80103f01:	8b 45 08             	mov    0x8(%ebp),%eax
80103f04:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103f08:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103f0c:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103f12:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103f16:	0f b6 c0             	movzbl %al,%eax
80103f19:	50                   	push   %eax
80103f1a:	6a 21                	push   $0x21
80103f1c:	e8 b9 ff ff ff       	call   80103eda <outb>
80103f21:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103f24:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103f28:	66 c1 e8 08          	shr    $0x8,%ax
80103f2c:	0f b6 c0             	movzbl %al,%eax
80103f2f:	50                   	push   %eax
80103f30:	68 a1 00 00 00       	push   $0xa1
80103f35:	e8 a0 ff ff ff       	call   80103eda <outb>
80103f3a:	83 c4 08             	add    $0x8,%esp
}
80103f3d:	90                   	nop
80103f3e:	c9                   	leave  
80103f3f:	c3                   	ret    

80103f40 <picenable>:

void
picenable(int irq)
{
80103f40:	55                   	push   %ebp
80103f41:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103f43:	8b 45 08             	mov    0x8(%ebp),%eax
80103f46:	ba 01 00 00 00       	mov    $0x1,%edx
80103f4b:	89 c1                	mov    %eax,%ecx
80103f4d:	d3 e2                	shl    %cl,%edx
80103f4f:	89 d0                	mov    %edx,%eax
80103f51:	f7 d0                	not    %eax
80103f53:	89 c2                	mov    %eax,%edx
80103f55:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103f5c:	21 d0                	and    %edx,%eax
80103f5e:	0f b7 c0             	movzwl %ax,%eax
80103f61:	50                   	push   %eax
80103f62:	e8 94 ff ff ff       	call   80103efb <picsetmask>
80103f67:	83 c4 04             	add    $0x4,%esp
}
80103f6a:	90                   	nop
80103f6b:	c9                   	leave  
80103f6c:	c3                   	ret    

80103f6d <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103f6d:	55                   	push   %ebp
80103f6e:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103f70:	68 ff 00 00 00       	push   $0xff
80103f75:	6a 21                	push   $0x21
80103f77:	e8 5e ff ff ff       	call   80103eda <outb>
80103f7c:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103f7f:	68 ff 00 00 00       	push   $0xff
80103f84:	68 a1 00 00 00       	push   $0xa1
80103f89:	e8 4c ff ff ff       	call   80103eda <outb>
80103f8e:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103f91:	6a 11                	push   $0x11
80103f93:	6a 20                	push   $0x20
80103f95:	e8 40 ff ff ff       	call   80103eda <outb>
80103f9a:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103f9d:	6a 20                	push   $0x20
80103f9f:	6a 21                	push   $0x21
80103fa1:	e8 34 ff ff ff       	call   80103eda <outb>
80103fa6:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103fa9:	6a 04                	push   $0x4
80103fab:	6a 21                	push   $0x21
80103fad:	e8 28 ff ff ff       	call   80103eda <outb>
80103fb2:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103fb5:	6a 03                	push   $0x3
80103fb7:	6a 21                	push   $0x21
80103fb9:	e8 1c ff ff ff       	call   80103eda <outb>
80103fbe:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103fc1:	6a 11                	push   $0x11
80103fc3:	68 a0 00 00 00       	push   $0xa0
80103fc8:	e8 0d ff ff ff       	call   80103eda <outb>
80103fcd:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103fd0:	6a 28                	push   $0x28
80103fd2:	68 a1 00 00 00       	push   $0xa1
80103fd7:	e8 fe fe ff ff       	call   80103eda <outb>
80103fdc:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103fdf:	6a 02                	push   $0x2
80103fe1:	68 a1 00 00 00       	push   $0xa1
80103fe6:	e8 ef fe ff ff       	call   80103eda <outb>
80103feb:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103fee:	6a 03                	push   $0x3
80103ff0:	68 a1 00 00 00       	push   $0xa1
80103ff5:	e8 e0 fe ff ff       	call   80103eda <outb>
80103ffa:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103ffd:	6a 68                	push   $0x68
80103fff:	6a 20                	push   $0x20
80104001:	e8 d4 fe ff ff       	call   80103eda <outb>
80104006:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80104009:	6a 0a                	push   $0xa
8010400b:	6a 20                	push   $0x20
8010400d:	e8 c8 fe ff ff       	call   80103eda <outb>
80104012:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80104015:	6a 68                	push   $0x68
80104017:	68 a0 00 00 00       	push   $0xa0
8010401c:	e8 b9 fe ff ff       	call   80103eda <outb>
80104021:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80104024:	6a 0a                	push   $0xa
80104026:	68 a0 00 00 00       	push   $0xa0
8010402b:	e8 aa fe ff ff       	call   80103eda <outb>
80104030:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80104033:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
8010403a:	66 83 f8 ff          	cmp    $0xffff,%ax
8010403e:	74 13                	je     80104053 <picinit+0xe6>
    picsetmask(irqmask);
80104040:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80104047:	0f b7 c0             	movzwl %ax,%eax
8010404a:	50                   	push   %eax
8010404b:	e8 ab fe ff ff       	call   80103efb <picsetmask>
80104050:	83 c4 04             	add    $0x4,%esp
}
80104053:	90                   	nop
80104054:	c9                   	leave  
80104055:	c3                   	ret    

80104056 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104056:	55                   	push   %ebp
80104057:	89 e5                	mov    %esp,%ebp
80104059:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
8010405c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80104063:	8b 45 0c             	mov    0xc(%ebp),%eax
80104066:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010406c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010406f:	8b 10                	mov    (%eax),%edx
80104071:	8b 45 08             	mov    0x8(%ebp),%eax
80104074:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80104076:	e8 23 cf ff ff       	call   80100f9e <filealloc>
8010407b:	89 c2                	mov    %eax,%edx
8010407d:	8b 45 08             	mov    0x8(%ebp),%eax
80104080:	89 10                	mov    %edx,(%eax)
80104082:	8b 45 08             	mov    0x8(%ebp),%eax
80104085:	8b 00                	mov    (%eax),%eax
80104087:	85 c0                	test   %eax,%eax
80104089:	0f 84 ca 00 00 00    	je     80104159 <pipealloc+0x103>
8010408f:	e8 0a cf ff ff       	call   80100f9e <filealloc>
80104094:	89 c2                	mov    %eax,%edx
80104096:	8b 45 0c             	mov    0xc(%ebp),%eax
80104099:	89 10                	mov    %edx,(%eax)
8010409b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010409e:	8b 00                	mov    (%eax),%eax
801040a0:	85 c0                	test   %eax,%eax
801040a2:	0f 84 b1 00 00 00    	je     80104159 <pipealloc+0x103>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801040a8:	e8 bd eb ff ff       	call   80102c6a <kalloc>
801040ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
801040b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801040b4:	0f 84 a2 00 00 00    	je     8010415c <pipealloc+0x106>
    goto bad;
  p->readopen = 1;
801040ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040bd:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801040c4:	00 00 00 
  p->writeopen = 1;
801040c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040ca:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801040d1:	00 00 00 
  p->nwrite = 0;
801040d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040d7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801040de:	00 00 00 
  p->nread = 0;
801040e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040e4:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801040eb:	00 00 00 
  initlock(&p->lock, "pipe");
801040ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040f1:	83 ec 08             	sub    $0x8,%esp
801040f4:	68 dc 88 10 80       	push   $0x801088dc
801040f9:	50                   	push   %eax
801040fa:	e8 23 0f 00 00       	call   80105022 <initlock>
801040ff:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104102:	8b 45 08             	mov    0x8(%ebp),%eax
80104105:	8b 00                	mov    (%eax),%eax
80104107:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010410d:	8b 45 08             	mov    0x8(%ebp),%eax
80104110:	8b 00                	mov    (%eax),%eax
80104112:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104116:	8b 45 08             	mov    0x8(%ebp),%eax
80104119:	8b 00                	mov    (%eax),%eax
8010411b:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010411f:	8b 45 08             	mov    0x8(%ebp),%eax
80104122:	8b 00                	mov    (%eax),%eax
80104124:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104127:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010412a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010412d:	8b 00                	mov    (%eax),%eax
8010412f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104135:	8b 45 0c             	mov    0xc(%ebp),%eax
80104138:	8b 00                	mov    (%eax),%eax
8010413a:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010413e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104141:	8b 00                	mov    (%eax),%eax
80104143:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104147:	8b 45 0c             	mov    0xc(%ebp),%eax
8010414a:	8b 00                	mov    (%eax),%eax
8010414c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010414f:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80104152:	b8 00 00 00 00       	mov    $0x0,%eax
80104157:	eb 51                	jmp    801041aa <pipealloc+0x154>
    goto bad;
80104159:	90                   	nop
8010415a:	eb 01                	jmp    8010415d <pipealloc+0x107>
    goto bad;
8010415c:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
8010415d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104161:	74 0e                	je     80104171 <pipealloc+0x11b>
    kfree((char*)p);
80104163:	83 ec 0c             	sub    $0xc,%esp
80104166:	ff 75 f4             	pushl  -0xc(%ebp)
80104169:	e8 5f ea ff ff       	call   80102bcd <kfree>
8010416e:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80104171:	8b 45 08             	mov    0x8(%ebp),%eax
80104174:	8b 00                	mov    (%eax),%eax
80104176:	85 c0                	test   %eax,%eax
80104178:	74 11                	je     8010418b <pipealloc+0x135>
    fileclose(*f0);
8010417a:	8b 45 08             	mov    0x8(%ebp),%eax
8010417d:	8b 00                	mov    (%eax),%eax
8010417f:	83 ec 0c             	sub    $0xc,%esp
80104182:	50                   	push   %eax
80104183:	e8 d4 ce ff ff       	call   8010105c <fileclose>
80104188:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010418b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010418e:	8b 00                	mov    (%eax),%eax
80104190:	85 c0                	test   %eax,%eax
80104192:	74 11                	je     801041a5 <pipealloc+0x14f>
    fileclose(*f1);
80104194:	8b 45 0c             	mov    0xc(%ebp),%eax
80104197:	8b 00                	mov    (%eax),%eax
80104199:	83 ec 0c             	sub    $0xc,%esp
8010419c:	50                   	push   %eax
8010419d:	e8 ba ce ff ff       	call   8010105c <fileclose>
801041a2:	83 c4 10             	add    $0x10,%esp
  return -1;
801041a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041aa:	c9                   	leave  
801041ab:	c3                   	ret    

801041ac <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801041ac:	55                   	push   %ebp
801041ad:	89 e5                	mov    %esp,%ebp
801041af:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
801041b2:	8b 45 08             	mov    0x8(%ebp),%eax
801041b5:	83 ec 0c             	sub    $0xc,%esp
801041b8:	50                   	push   %eax
801041b9:	e8 86 0e 00 00       	call   80105044 <acquire>
801041be:	83 c4 10             	add    $0x10,%esp
  if(writable){
801041c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801041c5:	74 23                	je     801041ea <pipeclose+0x3e>
    p->writeopen = 0;
801041c7:	8b 45 08             	mov    0x8(%ebp),%eax
801041ca:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801041d1:	00 00 00 
    wakeup(&p->nread);
801041d4:	8b 45 08             	mov    0x8(%ebp),%eax
801041d7:	05 34 02 00 00       	add    $0x234,%eax
801041dc:	83 ec 0c             	sub    $0xc,%esp
801041df:	50                   	push   %eax
801041e0:	e8 51 0c 00 00       	call   80104e36 <wakeup>
801041e5:	83 c4 10             	add    $0x10,%esp
801041e8:	eb 21                	jmp    8010420b <pipeclose+0x5f>
  } else {
    p->readopen = 0;
801041ea:	8b 45 08             	mov    0x8(%ebp),%eax
801041ed:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801041f4:	00 00 00 
    wakeup(&p->nwrite);
801041f7:	8b 45 08             	mov    0x8(%ebp),%eax
801041fa:	05 38 02 00 00       	add    $0x238,%eax
801041ff:	83 ec 0c             	sub    $0xc,%esp
80104202:	50                   	push   %eax
80104203:	e8 2e 0c 00 00       	call   80104e36 <wakeup>
80104208:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010420b:	8b 45 08             	mov    0x8(%ebp),%eax
8010420e:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104214:	85 c0                	test   %eax,%eax
80104216:	75 2c                	jne    80104244 <pipeclose+0x98>
80104218:	8b 45 08             	mov    0x8(%ebp),%eax
8010421b:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104221:	85 c0                	test   %eax,%eax
80104223:	75 1f                	jne    80104244 <pipeclose+0x98>
    release(&p->lock);
80104225:	8b 45 08             	mov    0x8(%ebp),%eax
80104228:	83 ec 0c             	sub    $0xc,%esp
8010422b:	50                   	push   %eax
8010422c:	e8 7a 0e 00 00       	call   801050ab <release>
80104231:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80104234:	83 ec 0c             	sub    $0xc,%esp
80104237:	ff 75 08             	pushl  0x8(%ebp)
8010423a:	e8 8e e9 ff ff       	call   80102bcd <kfree>
8010423f:	83 c4 10             	add    $0x10,%esp
80104242:	eb 0f                	jmp    80104253 <pipeclose+0xa7>
  } else
    release(&p->lock);
80104244:	8b 45 08             	mov    0x8(%ebp),%eax
80104247:	83 ec 0c             	sub    $0xc,%esp
8010424a:	50                   	push   %eax
8010424b:	e8 5b 0e 00 00       	call   801050ab <release>
80104250:	83 c4 10             	add    $0x10,%esp
}
80104253:	90                   	nop
80104254:	c9                   	leave  
80104255:	c3                   	ret    

80104256 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104256:	55                   	push   %ebp
80104257:	89 e5                	mov    %esp,%ebp
80104259:	53                   	push   %ebx
8010425a:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
8010425d:	8b 45 08             	mov    0x8(%ebp),%eax
80104260:	83 ec 0c             	sub    $0xc,%esp
80104263:	50                   	push   %eax
80104264:	e8 db 0d 00 00       	call   80105044 <acquire>
80104269:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
8010426c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104273:	e9 ae 00 00 00       	jmp    80104326 <pipewrite+0xd0>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80104278:	8b 45 08             	mov    0x8(%ebp),%eax
8010427b:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104281:	85 c0                	test   %eax,%eax
80104283:	74 0d                	je     80104292 <pipewrite+0x3c>
80104285:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010428b:	8b 40 24             	mov    0x24(%eax),%eax
8010428e:	85 c0                	test   %eax,%eax
80104290:	74 19                	je     801042ab <pipewrite+0x55>
        release(&p->lock);
80104292:	8b 45 08             	mov    0x8(%ebp),%eax
80104295:	83 ec 0c             	sub    $0xc,%esp
80104298:	50                   	push   %eax
80104299:	e8 0d 0e 00 00       	call   801050ab <release>
8010429e:	83 c4 10             	add    $0x10,%esp
        return -1;
801042a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042a6:	e9 a9 00 00 00       	jmp    80104354 <pipewrite+0xfe>
      }
      wakeup(&p->nread);
801042ab:	8b 45 08             	mov    0x8(%ebp),%eax
801042ae:	05 34 02 00 00       	add    $0x234,%eax
801042b3:	83 ec 0c             	sub    $0xc,%esp
801042b6:	50                   	push   %eax
801042b7:	e8 7a 0b 00 00       	call   80104e36 <wakeup>
801042bc:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801042bf:	8b 45 08             	mov    0x8(%ebp),%eax
801042c2:	8b 55 08             	mov    0x8(%ebp),%edx
801042c5:	81 c2 38 02 00 00    	add    $0x238,%edx
801042cb:	83 ec 08             	sub    $0x8,%esp
801042ce:	50                   	push   %eax
801042cf:	52                   	push   %edx
801042d0:	e8 76 0a 00 00       	call   80104d4b <sleep>
801042d5:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801042d8:	8b 45 08             	mov    0x8(%ebp),%eax
801042db:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
801042e1:	8b 45 08             	mov    0x8(%ebp),%eax
801042e4:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801042ea:	05 00 02 00 00       	add    $0x200,%eax
801042ef:	39 c2                	cmp    %eax,%edx
801042f1:	74 85                	je     80104278 <pipewrite+0x22>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801042f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801042f9:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801042fc:	8b 45 08             	mov    0x8(%ebp),%eax
801042ff:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104305:	8d 48 01             	lea    0x1(%eax),%ecx
80104308:	8b 55 08             	mov    0x8(%ebp),%edx
8010430b:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104311:	25 ff 01 00 00       	and    $0x1ff,%eax
80104316:	89 c1                	mov    %eax,%ecx
80104318:	0f b6 13             	movzbl (%ebx),%edx
8010431b:	8b 45 08             	mov    0x8(%ebp),%eax
8010431e:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
80104322:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104326:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104329:	3b 45 10             	cmp    0x10(%ebp),%eax
8010432c:	7c aa                	jl     801042d8 <pipewrite+0x82>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010432e:	8b 45 08             	mov    0x8(%ebp),%eax
80104331:	05 34 02 00 00       	add    $0x234,%eax
80104336:	83 ec 0c             	sub    $0xc,%esp
80104339:	50                   	push   %eax
8010433a:	e8 f7 0a 00 00       	call   80104e36 <wakeup>
8010433f:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104342:	8b 45 08             	mov    0x8(%ebp),%eax
80104345:	83 ec 0c             	sub    $0xc,%esp
80104348:	50                   	push   %eax
80104349:	e8 5d 0d 00 00       	call   801050ab <release>
8010434e:	83 c4 10             	add    $0x10,%esp
  return n;
80104351:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104354:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104357:	c9                   	leave  
80104358:	c3                   	ret    

80104359 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104359:	55                   	push   %ebp
8010435a:	89 e5                	mov    %esp,%ebp
8010435c:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
8010435f:	8b 45 08             	mov    0x8(%ebp),%eax
80104362:	83 ec 0c             	sub    $0xc,%esp
80104365:	50                   	push   %eax
80104366:	e8 d9 0c 00 00       	call   80105044 <acquire>
8010436b:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010436e:	eb 3f                	jmp    801043af <piperead+0x56>
    if(proc->killed){
80104370:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104376:	8b 40 24             	mov    0x24(%eax),%eax
80104379:	85 c0                	test   %eax,%eax
8010437b:	74 19                	je     80104396 <piperead+0x3d>
      release(&p->lock);
8010437d:	8b 45 08             	mov    0x8(%ebp),%eax
80104380:	83 ec 0c             	sub    $0xc,%esp
80104383:	50                   	push   %eax
80104384:	e8 22 0d 00 00       	call   801050ab <release>
80104389:	83 c4 10             	add    $0x10,%esp
      return -1;
8010438c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104391:	e9 be 00 00 00       	jmp    80104454 <piperead+0xfb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104396:	8b 45 08             	mov    0x8(%ebp),%eax
80104399:	8b 55 08             	mov    0x8(%ebp),%edx
8010439c:	81 c2 34 02 00 00    	add    $0x234,%edx
801043a2:	83 ec 08             	sub    $0x8,%esp
801043a5:	50                   	push   %eax
801043a6:	52                   	push   %edx
801043a7:	e8 9f 09 00 00       	call   80104d4b <sleep>
801043ac:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801043af:	8b 45 08             	mov    0x8(%ebp),%eax
801043b2:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801043b8:	8b 45 08             	mov    0x8(%ebp),%eax
801043bb:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801043c1:	39 c2                	cmp    %eax,%edx
801043c3:	75 0d                	jne    801043d2 <piperead+0x79>
801043c5:	8b 45 08             	mov    0x8(%ebp),%eax
801043c8:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801043ce:	85 c0                	test   %eax,%eax
801043d0:	75 9e                	jne    80104370 <piperead+0x17>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801043d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801043d9:	eb 48                	jmp    80104423 <piperead+0xca>
    if(p->nread == p->nwrite)
801043db:	8b 45 08             	mov    0x8(%ebp),%eax
801043de:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801043e4:	8b 45 08             	mov    0x8(%ebp),%eax
801043e7:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801043ed:	39 c2                	cmp    %eax,%edx
801043ef:	74 3c                	je     8010442d <piperead+0xd4>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801043f1:	8b 45 08             	mov    0x8(%ebp),%eax
801043f4:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801043fa:	8d 48 01             	lea    0x1(%eax),%ecx
801043fd:	8b 55 08             	mov    0x8(%ebp),%edx
80104400:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104406:	25 ff 01 00 00       	and    $0x1ff,%eax
8010440b:	89 c1                	mov    %eax,%ecx
8010440d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104410:	8b 45 0c             	mov    0xc(%ebp),%eax
80104413:	01 c2                	add    %eax,%edx
80104415:	8b 45 08             	mov    0x8(%ebp),%eax
80104418:	0f b6 44 08 34       	movzbl 0x34(%eax,%ecx,1),%eax
8010441d:	88 02                	mov    %al,(%edx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010441f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104423:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104426:	3b 45 10             	cmp    0x10(%ebp),%eax
80104429:	7c b0                	jl     801043db <piperead+0x82>
8010442b:	eb 01                	jmp    8010442e <piperead+0xd5>
      break;
8010442d:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010442e:	8b 45 08             	mov    0x8(%ebp),%eax
80104431:	05 38 02 00 00       	add    $0x238,%eax
80104436:	83 ec 0c             	sub    $0xc,%esp
80104439:	50                   	push   %eax
8010443a:	e8 f7 09 00 00       	call   80104e36 <wakeup>
8010443f:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104442:	8b 45 08             	mov    0x8(%ebp),%eax
80104445:	83 ec 0c             	sub    $0xc,%esp
80104448:	50                   	push   %eax
80104449:	e8 5d 0c 00 00       	call   801050ab <release>
8010444e:	83 c4 10             	add    $0x10,%esp
  return i;
80104451:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104454:	c9                   	leave  
80104455:	c3                   	ret    

80104456 <readeflags>:
{
80104456:	55                   	push   %ebp
80104457:	89 e5                	mov    %esp,%ebp
80104459:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010445c:	9c                   	pushf  
8010445d:	58                   	pop    %eax
8010445e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104461:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104464:	c9                   	leave  
80104465:	c3                   	ret    

80104466 <sti>:
{
80104466:	55                   	push   %ebp
80104467:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104469:	fb                   	sti    
}
8010446a:	90                   	nop
8010446b:	5d                   	pop    %ebp
8010446c:	c3                   	ret    

8010446d <halt>:
}

// CS550: to solve the 100%-CPU-utilization-when-idling problem - "hlt" instruction puts CPU to sleep
static inline void
halt()
{
8010446d:	55                   	push   %ebp
8010446e:	89 e5                	mov    %esp,%ebp
    asm volatile("hlt" : : :"memory");
80104470:	f4                   	hlt    
}
80104471:	90                   	nop
80104472:	5d                   	pop    %ebp
80104473:	c3                   	ret    

80104474 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80104474:	55                   	push   %ebp
80104475:	89 e5                	mov    %esp,%ebp
80104477:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
8010447a:	83 ec 08             	sub    $0x8,%esp
8010447d:	68 e1 88 10 80       	push   $0x801088e1
80104482:	68 60 29 11 80       	push   $0x80112960
80104487:	e8 96 0b 00 00       	call   80105022 <initlock>
8010448c:	83 c4 10             	add    $0x10,%esp
}
8010448f:	90                   	nop
80104490:	c9                   	leave  
80104491:	c3                   	ret    

80104492 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104492:	55                   	push   %ebp
80104493:	89 e5                	mov    %esp,%ebp
80104495:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104498:	83 ec 0c             	sub    $0xc,%esp
8010449b:	68 60 29 11 80       	push   $0x80112960
801044a0:	e8 9f 0b 00 00       	call   80105044 <acquire>
801044a5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044a8:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
801044af:	eb 0e                	jmp    801044bf <allocproc+0x2d>
    if(p->state == UNUSED)
801044b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044b4:	8b 40 0c             	mov    0xc(%eax),%eax
801044b7:	85 c0                	test   %eax,%eax
801044b9:	74 27                	je     801044e2 <allocproc+0x50>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044bb:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801044bf:	81 7d f4 94 48 11 80 	cmpl   $0x80114894,-0xc(%ebp)
801044c6:	72 e9                	jb     801044b1 <allocproc+0x1f>
      goto found;
  release(&ptable.lock);
801044c8:	83 ec 0c             	sub    $0xc,%esp
801044cb:	68 60 29 11 80       	push   $0x80112960
801044d0:	e8 d6 0b 00 00       	call   801050ab <release>
801044d5:	83 c4 10             	add    $0x10,%esp
  return 0;
801044d8:	b8 00 00 00 00       	mov    $0x0,%eax
801044dd:	e9 b4 00 00 00       	jmp    80104596 <allocproc+0x104>
      goto found;
801044e2:	90                   	nop

found:
  p->state = EMBRYO;
801044e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044e6:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
801044ed:	a1 04 b0 10 80       	mov    0x8010b004,%eax
801044f2:	8d 50 01             	lea    0x1(%eax),%edx
801044f5:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
801044fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044fe:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
80104501:	83 ec 0c             	sub    $0xc,%esp
80104504:	68 60 29 11 80       	push   $0x80112960
80104509:	e8 9d 0b 00 00       	call   801050ab <release>
8010450e:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104511:	e8 54 e7 ff ff       	call   80102c6a <kalloc>
80104516:	89 c2                	mov    %eax,%edx
80104518:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010451b:	89 50 08             	mov    %edx,0x8(%eax)
8010451e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104521:	8b 40 08             	mov    0x8(%eax),%eax
80104524:	85 c0                	test   %eax,%eax
80104526:	75 11                	jne    80104539 <allocproc+0xa7>
    p->state = UNUSED;
80104528:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010452b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104532:	b8 00 00 00 00       	mov    $0x0,%eax
80104537:	eb 5d                	jmp    80104596 <allocproc+0x104>
  }
  sp = p->kstack + KSTACKSIZE;
80104539:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010453c:	8b 40 08             	mov    0x8(%eax),%eax
8010453f:	05 00 10 00 00       	add    $0x1000,%eax
80104544:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104547:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
8010454b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010454e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104551:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104554:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104558:	ba 84 66 10 80       	mov    $0x80106684,%edx
8010455d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104560:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104562:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104566:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104569:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010456c:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
8010456f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104572:	8b 40 1c             	mov    0x1c(%eax),%eax
80104575:	83 ec 04             	sub    $0x4,%esp
80104578:	6a 14                	push   $0x14
8010457a:	6a 00                	push   $0x0
8010457c:	50                   	push   %eax
8010457d:	e8 25 0d 00 00       	call   801052a7 <memset>
80104582:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104585:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104588:	8b 40 1c             	mov    0x1c(%eax),%eax
8010458b:	ba 05 4d 10 80       	mov    $0x80104d05,%edx
80104590:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80104593:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104596:	c9                   	leave  
80104597:	c3                   	ret    

80104598 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104598:	55                   	push   %ebp
80104599:	89 e5                	mov    %esp,%ebp
8010459b:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
8010459e:	e8 ef fe ff ff       	call   80104492 <allocproc>
801045a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
801045a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a9:	a3 48 b6 10 80       	mov    %eax,0x8010b648
  if((p->pgdir = setupkvm()) == 0)
801045ae:	e8 98 37 00 00       	call   80107d4b <setupkvm>
801045b3:	89 c2                	mov    %eax,%edx
801045b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b8:	89 50 04             	mov    %edx,0x4(%eax)
801045bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045be:	8b 40 04             	mov    0x4(%eax),%eax
801045c1:	85 c0                	test   %eax,%eax
801045c3:	75 0d                	jne    801045d2 <userinit+0x3a>
    panic("userinit: out of memory?");
801045c5:	83 ec 0c             	sub    $0xc,%esp
801045c8:	68 e8 88 10 80       	push   $0x801088e8
801045cd:	e8 95 bf ff ff       	call   80100567 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801045d2:	ba 2c 00 00 00       	mov    $0x2c,%edx
801045d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045da:	8b 40 04             	mov    0x4(%eax),%eax
801045dd:	83 ec 04             	sub    $0x4,%esp
801045e0:	52                   	push   %edx
801045e1:	68 e0 b4 10 80       	push   $0x8010b4e0
801045e6:	50                   	push   %eax
801045e7:	e8 ba 39 00 00       	call   80107fa6 <inituvm>
801045ec:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
801045ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f2:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801045f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045fb:	8b 40 18             	mov    0x18(%eax),%eax
801045fe:	83 ec 04             	sub    $0x4,%esp
80104601:	6a 4c                	push   $0x4c
80104603:	6a 00                	push   $0x0
80104605:	50                   	push   %eax
80104606:	e8 9c 0c 00 00       	call   801052a7 <memset>
8010460b:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010460e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104611:	8b 40 18             	mov    0x18(%eax),%eax
80104614:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010461a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010461d:	8b 40 18             	mov    0x18(%eax),%eax
80104620:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104626:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104629:	8b 50 18             	mov    0x18(%eax),%edx
8010462c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010462f:	8b 40 18             	mov    0x18(%eax),%eax
80104632:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104636:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010463a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010463d:	8b 50 18             	mov    0x18(%eax),%edx
80104640:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104643:	8b 40 18             	mov    0x18(%eax),%eax
80104646:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010464a:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010464e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104651:	8b 40 18             	mov    0x18(%eax),%eax
80104654:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010465b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010465e:	8b 40 18             	mov    0x18(%eax),%eax
80104661:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104668:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010466b:	8b 40 18             	mov    0x18(%eax),%eax
8010466e:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104675:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104678:	83 c0 6c             	add    $0x6c,%eax
8010467b:	83 ec 04             	sub    $0x4,%esp
8010467e:	6a 10                	push   $0x10
80104680:	68 01 89 10 80       	push   $0x80108901
80104685:	50                   	push   %eax
80104686:	e8 1f 0e 00 00       	call   801054aa <safestrcpy>
8010468b:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
8010468e:	83 ec 0c             	sub    $0xc,%esp
80104691:	68 0a 89 10 80       	push   $0x8010890a
80104696:	e8 8f de ff ff       	call   8010252a <namei>
8010469b:	83 c4 10             	add    $0x10,%esp
8010469e:	89 c2                	mov    %eax,%edx
801046a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a3:	89 50 68             	mov    %edx,0x68(%eax)

  p->state = RUNNABLE;
801046a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a9:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
801046b0:	90                   	nop
801046b1:	c9                   	leave  
801046b2:	c3                   	ret    

801046b3 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801046b3:	55                   	push   %ebp
801046b4:	89 e5                	mov    %esp,%ebp
801046b6:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
801046b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046bf:	8b 00                	mov    (%eax),%eax
801046c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801046c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801046c8:	7e 31                	jle    801046fb <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801046ca:	8b 55 08             	mov    0x8(%ebp),%edx
801046cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046d0:	01 c2                	add    %eax,%edx
801046d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046d8:	8b 40 04             	mov    0x4(%eax),%eax
801046db:	83 ec 04             	sub    $0x4,%esp
801046de:	52                   	push   %edx
801046df:	ff 75 f4             	pushl  -0xc(%ebp)
801046e2:	50                   	push   %eax
801046e3:	e8 0b 3a 00 00       	call   801080f3 <allocuvm>
801046e8:	83 c4 10             	add    $0x10,%esp
801046eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801046ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801046f2:	75 3e                	jne    80104732 <growproc+0x7f>
      return -1;
801046f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046f9:	eb 59                	jmp    80104754 <growproc+0xa1>
  } else if(n < 0){
801046fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801046ff:	79 31                	jns    80104732 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104701:	8b 55 08             	mov    0x8(%ebp),%edx
80104704:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104707:	01 c2                	add    %eax,%edx
80104709:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010470f:	8b 40 04             	mov    0x4(%eax),%eax
80104712:	83 ec 04             	sub    $0x4,%esp
80104715:	52                   	push   %edx
80104716:	ff 75 f4             	pushl  -0xc(%ebp)
80104719:	50                   	push   %eax
8010471a:	e8 9d 3a 00 00       	call   801081bc <deallocuvm>
8010471f:	83 c4 10             	add    $0x10,%esp
80104722:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104725:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104729:	75 07                	jne    80104732 <growproc+0x7f>
      return -1;
8010472b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104730:	eb 22                	jmp    80104754 <growproc+0xa1>
  }
  proc->sz = sz;
80104732:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104738:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010473b:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
8010473d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104743:	83 ec 0c             	sub    $0xc,%esp
80104746:	50                   	push   %eax
80104747:	e8 e6 36 00 00       	call   80107e32 <switchuvm>
8010474c:	83 c4 10             	add    $0x10,%esp
  return 0;
8010474f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104754:	c9                   	leave  
80104755:	c3                   	ret    

80104756 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104756:	55                   	push   %ebp
80104757:	89 e5                	mov    %esp,%ebp
80104759:	57                   	push   %edi
8010475a:	56                   	push   %esi
8010475b:	53                   	push   %ebx
8010475c:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
8010475f:	e8 2e fd ff ff       	call   80104492 <allocproc>
80104764:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104767:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010476b:	75 0a                	jne    80104777 <fork+0x21>
    return -1;
8010476d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104772:	e9 6a 01 00 00       	jmp    801048e1 <fork+0x18b>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104777:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010477d:	8b 10                	mov    (%eax),%edx
8010477f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104785:	8b 40 04             	mov    0x4(%eax),%eax
80104788:	83 ec 08             	sub    $0x8,%esp
8010478b:	52                   	push   %edx
8010478c:	50                   	push   %eax
8010478d:	e8 c8 3b 00 00       	call   8010835a <copyuvm>
80104792:	83 c4 10             	add    $0x10,%esp
80104795:	89 c2                	mov    %eax,%edx
80104797:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010479a:	89 50 04             	mov    %edx,0x4(%eax)
8010479d:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047a0:	8b 40 04             	mov    0x4(%eax),%eax
801047a3:	85 c0                	test   %eax,%eax
801047a5:	75 30                	jne    801047d7 <fork+0x81>
    kfree(np->kstack);
801047a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047aa:	8b 40 08             	mov    0x8(%eax),%eax
801047ad:	83 ec 0c             	sub    $0xc,%esp
801047b0:	50                   	push   %eax
801047b1:	e8 17 e4 ff ff       	call   80102bcd <kfree>
801047b6:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
801047b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047bc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
801047c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047c6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
801047cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047d2:	e9 0a 01 00 00       	jmp    801048e1 <fork+0x18b>
  }
  np->sz = proc->sz;
801047d7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047dd:	8b 10                	mov    (%eax),%edx
801047df:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047e2:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
801047e4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801047eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047ee:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
801047f1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047f7:	8b 48 18             	mov    0x18(%eax),%ecx
801047fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047fd:	8b 40 18             	mov    0x18(%eax),%eax
80104800:	89 c2                	mov    %eax,%edx
80104802:	89 cb                	mov    %ecx,%ebx
80104804:	b8 13 00 00 00       	mov    $0x13,%eax
80104809:	89 d7                	mov    %edx,%edi
8010480b:	89 de                	mov    %ebx,%esi
8010480d:	89 c1                	mov    %eax,%ecx
8010480f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104811:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104814:	8b 40 18             	mov    0x18(%eax),%eax
80104817:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
8010481e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104825:	eb 43                	jmp    8010486a <fork+0x114>
    if(proc->ofile[i])
80104827:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010482d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104830:	83 c2 08             	add    $0x8,%edx
80104833:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104837:	85 c0                	test   %eax,%eax
80104839:	74 2b                	je     80104866 <fork+0x110>
      np->ofile[i] = filedup(proc->ofile[i]);
8010483b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104841:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104844:	83 c2 08             	add    $0x8,%edx
80104847:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010484b:	83 ec 0c             	sub    $0xc,%esp
8010484e:	50                   	push   %eax
8010484f:	e8 b7 c7 ff ff       	call   8010100b <filedup>
80104854:	83 c4 10             	add    $0x10,%esp
80104857:	89 c1                	mov    %eax,%ecx
80104859:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010485c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010485f:	83 c2 08             	add    $0x8,%edx
80104862:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  for(i = 0; i < NOFILE; i++)
80104866:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010486a:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
8010486e:	7e b7                	jle    80104827 <fork+0xd1>
  np->cwd = idup(proc->cwd);
80104870:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104876:	8b 40 68             	mov    0x68(%eax),%eax
80104879:	83 ec 0c             	sub    $0xc,%esp
8010487c:	50                   	push   %eax
8010487d:	e8 b9 d0 ff ff       	call   8010193b <idup>
80104882:	83 c4 10             	add    $0x10,%esp
80104885:	89 c2                	mov    %eax,%edx
80104887:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010488a:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
8010488d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104893:	8d 50 6c             	lea    0x6c(%eax),%edx
80104896:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104899:	83 c0 6c             	add    $0x6c,%eax
8010489c:	83 ec 04             	sub    $0x4,%esp
8010489f:	6a 10                	push   $0x10
801048a1:	52                   	push   %edx
801048a2:	50                   	push   %eax
801048a3:	e8 02 0c 00 00       	call   801054aa <safestrcpy>
801048a8:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
801048ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048ae:	8b 40 10             	mov    0x10(%eax),%eax
801048b1:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
801048b4:	83 ec 0c             	sub    $0xc,%esp
801048b7:	68 60 29 11 80       	push   $0x80112960
801048bc:	e8 83 07 00 00       	call   80105044 <acquire>
801048c1:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
801048c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048c7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
801048ce:	83 ec 0c             	sub    $0xc,%esp
801048d1:	68 60 29 11 80       	push   $0x80112960
801048d6:	e8 d0 07 00 00       	call   801050ab <release>
801048db:	83 c4 10             	add    $0x10,%esp
  
  return pid;
801048de:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
801048e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048e4:	5b                   	pop    %ebx
801048e5:	5e                   	pop    %esi
801048e6:	5f                   	pop    %edi
801048e7:	5d                   	pop    %ebp
801048e8:	c3                   	ret    

801048e9 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
801048e9:	55                   	push   %ebp
801048ea:	89 e5                	mov    %esp,%ebp
801048ec:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
801048ef:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801048f6:	a1 48 b6 10 80       	mov    0x8010b648,%eax
801048fb:	39 c2                	cmp    %eax,%edx
801048fd:	75 0d                	jne    8010490c <exit+0x23>
    panic("init exiting");
801048ff:	83 ec 0c             	sub    $0xc,%esp
80104902:	68 0c 89 10 80       	push   $0x8010890c
80104907:	e8 5b bc ff ff       	call   80100567 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010490c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104913:	eb 48                	jmp    8010495d <exit+0x74>
    if(proc->ofile[fd]){
80104915:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010491b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010491e:	83 c2 08             	add    $0x8,%edx
80104921:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104925:	85 c0                	test   %eax,%eax
80104927:	74 30                	je     80104959 <exit+0x70>
      fileclose(proc->ofile[fd]);
80104929:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010492f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104932:	83 c2 08             	add    $0x8,%edx
80104935:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104939:	83 ec 0c             	sub    $0xc,%esp
8010493c:	50                   	push   %eax
8010493d:	e8 1a c7 ff ff       	call   8010105c <fileclose>
80104942:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104945:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010494b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010494e:	83 c2 08             	add    $0x8,%edx
80104951:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104958:	00 
  for(fd = 0; fd < NOFILE; fd++){
80104959:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010495d:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104961:	7e b2                	jle    80104915 <exit+0x2c>
    }
  }

  begin_op();
80104963:	e8 ee eb ff ff       	call   80103556 <begin_op>
  iput(proc->cwd);
80104968:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010496e:	8b 40 68             	mov    0x68(%eax),%eax
80104971:	83 ec 0c             	sub    $0xc,%esp
80104974:	50                   	push   %eax
80104975:	e8 cb d1 ff ff       	call   80101b45 <iput>
8010497a:	83 c4 10             	add    $0x10,%esp
  end_op();
8010497d:	e8 60 ec ff ff       	call   801035e2 <end_op>
  proc->cwd = 0;
80104982:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104988:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
8010498f:	83 ec 0c             	sub    $0xc,%esp
80104992:	68 60 29 11 80       	push   $0x80112960
80104997:	e8 a8 06 00 00       	call   80105044 <acquire>
8010499c:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
8010499f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049a5:	8b 40 14             	mov    0x14(%eax),%eax
801049a8:	83 ec 0c             	sub    $0xc,%esp
801049ab:	50                   	push   %eax
801049ac:	e8 46 04 00 00       	call   80104df7 <wakeup1>
801049b1:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049b4:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
801049bb:	eb 3c                	jmp    801049f9 <exit+0x110>
    if(p->parent == proc){
801049bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c0:	8b 50 14             	mov    0x14(%eax),%edx
801049c3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049c9:	39 c2                	cmp    %eax,%edx
801049cb:	75 28                	jne    801049f5 <exit+0x10c>
      p->parent = initproc;
801049cd:	8b 15 48 b6 10 80    	mov    0x8010b648,%edx
801049d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d6:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
801049d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049dc:	8b 40 0c             	mov    0xc(%eax),%eax
801049df:	83 f8 05             	cmp    $0x5,%eax
801049e2:	75 11                	jne    801049f5 <exit+0x10c>
        wakeup1(initproc);
801049e4:	a1 48 b6 10 80       	mov    0x8010b648,%eax
801049e9:	83 ec 0c             	sub    $0xc,%esp
801049ec:	50                   	push   %eax
801049ed:	e8 05 04 00 00       	call   80104df7 <wakeup1>
801049f2:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049f5:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801049f9:	81 7d f4 94 48 11 80 	cmpl   $0x80114894,-0xc(%ebp)
80104a00:	72 bb                	jb     801049bd <exit+0xd4>
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104a02:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a08:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104a0f:	e8 fa 01 00 00       	call   80104c0e <sched>
  panic("zombie exit");
80104a14:	83 ec 0c             	sub    $0xc,%esp
80104a17:	68 19 89 10 80       	push   $0x80108919
80104a1c:	e8 46 bb ff ff       	call   80100567 <panic>

80104a21 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104a21:	55                   	push   %ebp
80104a22:	89 e5                	mov    %esp,%ebp
80104a24:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104a27:	83 ec 0c             	sub    $0xc,%esp
80104a2a:	68 60 29 11 80       	push   $0x80112960
80104a2f:	e8 10 06 00 00       	call   80105044 <acquire>
80104a34:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104a37:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a3e:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104a45:	e9 a6 00 00 00       	jmp    80104af0 <wait+0xcf>
      if(p->parent != proc)
80104a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a4d:	8b 50 14             	mov    0x14(%eax),%edx
80104a50:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a56:	39 c2                	cmp    %eax,%edx
80104a58:	0f 85 8d 00 00 00    	jne    80104aeb <wait+0xca>
        continue;
      havekids = 1;
80104a5e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a68:	8b 40 0c             	mov    0xc(%eax),%eax
80104a6b:	83 f8 05             	cmp    $0x5,%eax
80104a6e:	75 7c                	jne    80104aec <wait+0xcb>
        // Found one.
        pid = p->pid;
80104a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a73:	8b 40 10             	mov    0x10(%eax),%eax
80104a76:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a7c:	8b 40 08             	mov    0x8(%eax),%eax
80104a7f:	83 ec 0c             	sub    $0xc,%esp
80104a82:	50                   	push   %eax
80104a83:	e8 45 e1 ff ff       	call   80102bcd <kfree>
80104a88:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a8e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a98:	8b 40 04             	mov    0x4(%eax),%eax
80104a9b:	83 ec 0c             	sub    $0xc,%esp
80104a9e:	50                   	push   %eax
80104a9f:	e8 d5 37 00 00       	call   80108279 <freevm>
80104aa4:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aaa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab4:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104abe:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac8:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104acf:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104ad6:	83 ec 0c             	sub    $0xc,%esp
80104ad9:	68 60 29 11 80       	push   $0x80112960
80104ade:	e8 c8 05 00 00       	call   801050ab <release>
80104ae3:	83 c4 10             	add    $0x10,%esp
        return pid;
80104ae6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104ae9:	eb 58                	jmp    80104b43 <wait+0x122>
        continue;
80104aeb:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104aec:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104af0:	81 7d f4 94 48 11 80 	cmpl   $0x80114894,-0xc(%ebp)
80104af7:	0f 82 4d ff ff ff    	jb     80104a4a <wait+0x29>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104afd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104b01:	74 0d                	je     80104b10 <wait+0xef>
80104b03:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b09:	8b 40 24             	mov    0x24(%eax),%eax
80104b0c:	85 c0                	test   %eax,%eax
80104b0e:	74 17                	je     80104b27 <wait+0x106>
      release(&ptable.lock);
80104b10:	83 ec 0c             	sub    $0xc,%esp
80104b13:	68 60 29 11 80       	push   $0x80112960
80104b18:	e8 8e 05 00 00       	call   801050ab <release>
80104b1d:	83 c4 10             	add    $0x10,%esp
      return -1;
80104b20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b25:	eb 1c                	jmp    80104b43 <wait+0x122>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104b27:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b2d:	83 ec 08             	sub    $0x8,%esp
80104b30:	68 60 29 11 80       	push   $0x80112960
80104b35:	50                   	push   %eax
80104b36:	e8 10 02 00 00       	call   80104d4b <sleep>
80104b3b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104b3e:	e9 f4 fe ff ff       	jmp    80104a37 <wait+0x16>
  }
}
80104b43:	c9                   	leave  
80104b44:	c3                   	ret    

80104b45 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104b45:	55                   	push   %ebp
80104b46:	89 e5                	mov    %esp,%ebp
80104b48:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int ran = 0; // CS550: to solve the 100%-CPU-utilization-when-idling problem
80104b4b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104b52:	e8 0f f9 ff ff       	call   80104466 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104b57:	83 ec 0c             	sub    $0xc,%esp
80104b5a:	68 60 29 11 80       	push   $0x80112960
80104b5f:	e8 e0 04 00 00       	call   80105044 <acquire>
80104b64:	83 c4 10             	add    $0x10,%esp
    ran = 0;
80104b67:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b6e:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104b75:	eb 6a                	jmp    80104be1 <scheduler+0x9c>
      if(p->state != RUNNABLE)
80104b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b7a:	8b 40 0c             	mov    0xc(%eax),%eax
80104b7d:	83 f8 03             	cmp    $0x3,%eax
80104b80:	75 5a                	jne    80104bdc <scheduler+0x97>
        continue;

      ran = 1;
80104b82:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b8c:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104b92:	83 ec 0c             	sub    $0xc,%esp
80104b95:	ff 75 f4             	pushl  -0xc(%ebp)
80104b98:	e8 95 32 00 00       	call   80107e32 <switchuvm>
80104b9d:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba3:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104baa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bb0:	8b 40 1c             	mov    0x1c(%eax),%eax
80104bb3:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104bba:	83 c2 04             	add    $0x4,%edx
80104bbd:	83 ec 08             	sub    $0x8,%esp
80104bc0:	50                   	push   %eax
80104bc1:	52                   	push   %edx
80104bc2:	e8 54 09 00 00       	call   8010551b <swtch>
80104bc7:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104bca:	e8 46 32 00 00       	call   80107e15 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104bcf:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104bd6:	00 00 00 00 
80104bda:	eb 01                	jmp    80104bdd <scheduler+0x98>
        continue;
80104bdc:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bdd:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104be1:	81 7d f4 94 48 11 80 	cmpl   $0x80114894,-0xc(%ebp)
80104be8:	72 8d                	jb     80104b77 <scheduler+0x32>
    }
    release(&ptable.lock);
80104bea:	83 ec 0c             	sub    $0xc,%esp
80104bed:	68 60 29 11 80       	push   $0x80112960
80104bf2:	e8 b4 04 00 00       	call   801050ab <release>
80104bf7:	83 c4 10             	add    $0x10,%esp

    if (ran == 0){
80104bfa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104bfe:	0f 85 4e ff ff ff    	jne    80104b52 <scheduler+0xd>
        halt();
80104c04:	e8 64 f8 ff ff       	call   8010446d <halt>
    sti();
80104c09:	e9 44 ff ff ff       	jmp    80104b52 <scheduler+0xd>

80104c0e <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104c0e:	55                   	push   %ebp
80104c0f:	89 e5                	mov    %esp,%ebp
80104c11:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80104c14:	83 ec 0c             	sub    $0xc,%esp
80104c17:	68 60 29 11 80       	push   $0x80112960
80104c1c:	e8 56 05 00 00       	call   80105177 <holding>
80104c21:	83 c4 10             	add    $0x10,%esp
80104c24:	85 c0                	test   %eax,%eax
80104c26:	75 0d                	jne    80104c35 <sched+0x27>
    panic("sched ptable.lock");
80104c28:	83 ec 0c             	sub    $0xc,%esp
80104c2b:	68 25 89 10 80       	push   $0x80108925
80104c30:	e8 32 b9 ff ff       	call   80100567 <panic>
  if(cpu->ncli != 1)
80104c35:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c3b:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104c41:	83 f8 01             	cmp    $0x1,%eax
80104c44:	74 0d                	je     80104c53 <sched+0x45>
    panic("sched locks");
80104c46:	83 ec 0c             	sub    $0xc,%esp
80104c49:	68 37 89 10 80       	push   $0x80108937
80104c4e:	e8 14 b9 ff ff       	call   80100567 <panic>
  if(proc->state == RUNNING)
80104c53:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c59:	8b 40 0c             	mov    0xc(%eax),%eax
80104c5c:	83 f8 04             	cmp    $0x4,%eax
80104c5f:	75 0d                	jne    80104c6e <sched+0x60>
    panic("sched running");
80104c61:	83 ec 0c             	sub    $0xc,%esp
80104c64:	68 43 89 10 80       	push   $0x80108943
80104c69:	e8 f9 b8 ff ff       	call   80100567 <panic>
  if(readeflags()&FL_IF)
80104c6e:	e8 e3 f7 ff ff       	call   80104456 <readeflags>
80104c73:	25 00 02 00 00       	and    $0x200,%eax
80104c78:	85 c0                	test   %eax,%eax
80104c7a:	74 0d                	je     80104c89 <sched+0x7b>
    panic("sched interruptible");
80104c7c:	83 ec 0c             	sub    $0xc,%esp
80104c7f:	68 51 89 10 80       	push   $0x80108951
80104c84:	e8 de b8 ff ff       	call   80100567 <panic>
  intena = cpu->intena;
80104c89:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c8f:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104c95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104c98:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c9e:	8b 40 04             	mov    0x4(%eax),%eax
80104ca1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ca8:	83 c2 1c             	add    $0x1c,%edx
80104cab:	83 ec 08             	sub    $0x8,%esp
80104cae:	50                   	push   %eax
80104caf:	52                   	push   %edx
80104cb0:	e8 66 08 00 00       	call   8010551b <swtch>
80104cb5:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104cb8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104cbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cc1:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104cc7:	90                   	nop
80104cc8:	c9                   	leave  
80104cc9:	c3                   	ret    

80104cca <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104cca:	55                   	push   %ebp
80104ccb:	89 e5                	mov    %esp,%ebp
80104ccd:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104cd0:	83 ec 0c             	sub    $0xc,%esp
80104cd3:	68 60 29 11 80       	push   $0x80112960
80104cd8:	e8 67 03 00 00       	call   80105044 <acquire>
80104cdd:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104ce0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ce6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104ced:	e8 1c ff ff ff       	call   80104c0e <sched>
  release(&ptable.lock);
80104cf2:	83 ec 0c             	sub    $0xc,%esp
80104cf5:	68 60 29 11 80       	push   $0x80112960
80104cfa:	e8 ac 03 00 00       	call   801050ab <release>
80104cff:	83 c4 10             	add    $0x10,%esp
}
80104d02:	90                   	nop
80104d03:	c9                   	leave  
80104d04:	c3                   	ret    

80104d05 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104d05:	55                   	push   %ebp
80104d06:	89 e5                	mov    %esp,%ebp
80104d08:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104d0b:	83 ec 0c             	sub    $0xc,%esp
80104d0e:	68 60 29 11 80       	push   $0x80112960
80104d13:	e8 93 03 00 00       	call   801050ab <release>
80104d18:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104d1b:	a1 08 b0 10 80       	mov    0x8010b008,%eax
80104d20:	85 c0                	test   %eax,%eax
80104d22:	74 24                	je     80104d48 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104d24:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
80104d2b:	00 00 00 
    iinit(ROOTDEV);
80104d2e:	83 ec 0c             	sub    $0xc,%esp
80104d31:	6a 01                	push   $0x1
80104d33:	e8 11 c9 ff ff       	call   80101649 <iinit>
80104d38:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104d3b:	83 ec 0c             	sub    $0xc,%esp
80104d3e:	6a 01                	push   $0x1
80104d40:	e8 f3 e5 ff ff       	call   80103338 <initlog>
80104d45:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104d48:	90                   	nop
80104d49:	c9                   	leave  
80104d4a:	c3                   	ret    

80104d4b <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104d4b:	55                   	push   %ebp
80104d4c:	89 e5                	mov    %esp,%ebp
80104d4e:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104d51:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d57:	85 c0                	test   %eax,%eax
80104d59:	75 0d                	jne    80104d68 <sleep+0x1d>
    panic("sleep");
80104d5b:	83 ec 0c             	sub    $0xc,%esp
80104d5e:	68 65 89 10 80       	push   $0x80108965
80104d63:	e8 ff b7 ff ff       	call   80100567 <panic>

  if(lk == 0)
80104d68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104d6c:	75 0d                	jne    80104d7b <sleep+0x30>
    panic("sleep without lk");
80104d6e:	83 ec 0c             	sub    $0xc,%esp
80104d71:	68 6b 89 10 80       	push   $0x8010896b
80104d76:	e8 ec b7 ff ff       	call   80100567 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104d7b:	81 7d 0c 60 29 11 80 	cmpl   $0x80112960,0xc(%ebp)
80104d82:	74 1e                	je     80104da2 <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104d84:	83 ec 0c             	sub    $0xc,%esp
80104d87:	68 60 29 11 80       	push   $0x80112960
80104d8c:	e8 b3 02 00 00       	call   80105044 <acquire>
80104d91:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104d94:	83 ec 0c             	sub    $0xc,%esp
80104d97:	ff 75 0c             	pushl  0xc(%ebp)
80104d9a:	e8 0c 03 00 00       	call   801050ab <release>
80104d9f:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104da2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104da8:	8b 55 08             	mov    0x8(%ebp),%edx
80104dab:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104dae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104db4:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104dbb:	e8 4e fe ff ff       	call   80104c0e <sched>

  // Tidy up.
  proc->chan = 0;
80104dc0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dc6:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104dcd:	81 7d 0c 60 29 11 80 	cmpl   $0x80112960,0xc(%ebp)
80104dd4:	74 1e                	je     80104df4 <sleep+0xa9>
    release(&ptable.lock);
80104dd6:	83 ec 0c             	sub    $0xc,%esp
80104dd9:	68 60 29 11 80       	push   $0x80112960
80104dde:	e8 c8 02 00 00       	call   801050ab <release>
80104de3:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104de6:	83 ec 0c             	sub    $0xc,%esp
80104de9:	ff 75 0c             	pushl  0xc(%ebp)
80104dec:	e8 53 02 00 00       	call   80105044 <acquire>
80104df1:	83 c4 10             	add    $0x10,%esp
  }
}
80104df4:	90                   	nop
80104df5:	c9                   	leave  
80104df6:	c3                   	ret    

80104df7 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104df7:	55                   	push   %ebp
80104df8:	89 e5                	mov    %esp,%ebp
80104dfa:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104dfd:	c7 45 fc 94 29 11 80 	movl   $0x80112994,-0x4(%ebp)
80104e04:	eb 24                	jmp    80104e2a <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104e06:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e09:	8b 40 0c             	mov    0xc(%eax),%eax
80104e0c:	83 f8 02             	cmp    $0x2,%eax
80104e0f:	75 15                	jne    80104e26 <wakeup1+0x2f>
80104e11:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e14:	8b 40 20             	mov    0x20(%eax),%eax
80104e17:	39 45 08             	cmp    %eax,0x8(%ebp)
80104e1a:	75 0a                	jne    80104e26 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104e1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e1f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e26:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104e2a:	81 7d fc 94 48 11 80 	cmpl   $0x80114894,-0x4(%ebp)
80104e31:	72 d3                	jb     80104e06 <wakeup1+0xf>
}
80104e33:	90                   	nop
80104e34:	c9                   	leave  
80104e35:	c3                   	ret    

80104e36 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104e36:	55                   	push   %ebp
80104e37:	89 e5                	mov    %esp,%ebp
80104e39:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104e3c:	83 ec 0c             	sub    $0xc,%esp
80104e3f:	68 60 29 11 80       	push   $0x80112960
80104e44:	e8 fb 01 00 00       	call   80105044 <acquire>
80104e49:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104e4c:	83 ec 0c             	sub    $0xc,%esp
80104e4f:	ff 75 08             	pushl  0x8(%ebp)
80104e52:	e8 a0 ff ff ff       	call   80104df7 <wakeup1>
80104e57:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104e5a:	83 ec 0c             	sub    $0xc,%esp
80104e5d:	68 60 29 11 80       	push   $0x80112960
80104e62:	e8 44 02 00 00       	call   801050ab <release>
80104e67:	83 c4 10             	add    $0x10,%esp
}
80104e6a:	90                   	nop
80104e6b:	c9                   	leave  
80104e6c:	c3                   	ret    

80104e6d <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104e6d:	55                   	push   %ebp
80104e6e:	89 e5                	mov    %esp,%ebp
80104e70:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104e73:	83 ec 0c             	sub    $0xc,%esp
80104e76:	68 60 29 11 80       	push   $0x80112960
80104e7b:	e8 c4 01 00 00       	call   80105044 <acquire>
80104e80:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e83:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104e8a:	eb 45                	jmp    80104ed1 <kill+0x64>
    if(p->pid == pid){
80104e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e8f:	8b 40 10             	mov    0x10(%eax),%eax
80104e92:	39 45 08             	cmp    %eax,0x8(%ebp)
80104e95:	75 36                	jne    80104ecd <kill+0x60>
      p->killed = 1;
80104e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e9a:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ea4:	8b 40 0c             	mov    0xc(%eax),%eax
80104ea7:	83 f8 02             	cmp    $0x2,%eax
80104eaa:	75 0a                	jne    80104eb6 <kill+0x49>
        p->state = RUNNABLE;
80104eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eaf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104eb6:	83 ec 0c             	sub    $0xc,%esp
80104eb9:	68 60 29 11 80       	push   $0x80112960
80104ebe:	e8 e8 01 00 00       	call   801050ab <release>
80104ec3:	83 c4 10             	add    $0x10,%esp
      return 0;
80104ec6:	b8 00 00 00 00       	mov    $0x0,%eax
80104ecb:	eb 22                	jmp    80104eef <kill+0x82>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ecd:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104ed1:	81 7d f4 94 48 11 80 	cmpl   $0x80114894,-0xc(%ebp)
80104ed8:	72 b2                	jb     80104e8c <kill+0x1f>
    }
  }
  release(&ptable.lock);
80104eda:	83 ec 0c             	sub    $0xc,%esp
80104edd:	68 60 29 11 80       	push   $0x80112960
80104ee2:	e8 c4 01 00 00       	call   801050ab <release>
80104ee7:	83 c4 10             	add    $0x10,%esp
  return -1;
80104eea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104eef:	c9                   	leave  
80104ef0:	c3                   	ret    

80104ef1 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104ef1:	55                   	push   %ebp
80104ef2:	89 e5                	mov    %esp,%ebp
80104ef4:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ef7:	c7 45 f0 94 29 11 80 	movl   $0x80112994,-0x10(%ebp)
80104efe:	e9 d7 00 00 00       	jmp    80104fda <procdump+0xe9>
    if(p->state == UNUSED)
80104f03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f06:	8b 40 0c             	mov    0xc(%eax),%eax
80104f09:	85 c0                	test   %eax,%eax
80104f0b:	0f 84 c4 00 00 00    	je     80104fd5 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f14:	8b 40 0c             	mov    0xc(%eax),%eax
80104f17:	83 f8 05             	cmp    $0x5,%eax
80104f1a:	77 23                	ja     80104f3f <procdump+0x4e>
80104f1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f1f:	8b 40 0c             	mov    0xc(%eax),%eax
80104f22:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104f29:	85 c0                	test   %eax,%eax
80104f2b:	74 12                	je     80104f3f <procdump+0x4e>
      state = states[p->state];
80104f2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f30:	8b 40 0c             	mov    0xc(%eax),%eax
80104f33:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104f3a:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104f3d:	eb 07                	jmp    80104f46 <procdump+0x55>
    else
      state = "???";
80104f3f:	c7 45 ec 7c 89 10 80 	movl   $0x8010897c,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104f46:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f49:	8d 50 6c             	lea    0x6c(%eax),%edx
80104f4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f4f:	8b 40 10             	mov    0x10(%eax),%eax
80104f52:	52                   	push   %edx
80104f53:	ff 75 ec             	pushl  -0x14(%ebp)
80104f56:	50                   	push   %eax
80104f57:	68 80 89 10 80       	push   $0x80108980
80104f5c:	e8 63 b4 ff ff       	call   801003c4 <cprintf>
80104f61:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104f64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f67:	8b 40 0c             	mov    0xc(%eax),%eax
80104f6a:	83 f8 02             	cmp    $0x2,%eax
80104f6d:	75 54                	jne    80104fc3 <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f72:	8b 40 1c             	mov    0x1c(%eax),%eax
80104f75:	8b 40 0c             	mov    0xc(%eax),%eax
80104f78:	83 c0 08             	add    $0x8,%eax
80104f7b:	89 c2                	mov    %eax,%edx
80104f7d:	83 ec 08             	sub    $0x8,%esp
80104f80:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104f83:	50                   	push   %eax
80104f84:	52                   	push   %edx
80104f85:	e8 73 01 00 00       	call   801050fd <getcallerpcs>
80104f8a:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104f8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104f94:	eb 1c                	jmp    80104fb2 <procdump+0xc1>
        cprintf(" %p", pc[i]);
80104f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f99:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104f9d:	83 ec 08             	sub    $0x8,%esp
80104fa0:	50                   	push   %eax
80104fa1:	68 89 89 10 80       	push   $0x80108989
80104fa6:	e8 19 b4 ff ff       	call   801003c4 <cprintf>
80104fab:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104fae:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104fb2:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104fb6:	7f 0b                	jg     80104fc3 <procdump+0xd2>
80104fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fbb:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104fbf:	85 c0                	test   %eax,%eax
80104fc1:	75 d3                	jne    80104f96 <procdump+0xa5>
    }
    cprintf("\n");
80104fc3:	83 ec 0c             	sub    $0xc,%esp
80104fc6:	68 8d 89 10 80       	push   $0x8010898d
80104fcb:	e8 f4 b3 ff ff       	call   801003c4 <cprintf>
80104fd0:	83 c4 10             	add    $0x10,%esp
80104fd3:	eb 01                	jmp    80104fd6 <procdump+0xe5>
      continue;
80104fd5:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fd6:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104fda:	81 7d f0 94 48 11 80 	cmpl   $0x80114894,-0x10(%ebp)
80104fe1:	0f 82 1c ff ff ff    	jb     80104f03 <procdump+0x12>
  }
}
80104fe7:	90                   	nop
80104fe8:	c9                   	leave  
80104fe9:	c3                   	ret    

80104fea <readeflags>:
{
80104fea:	55                   	push   %ebp
80104feb:	89 e5                	mov    %esp,%ebp
80104fed:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104ff0:	9c                   	pushf  
80104ff1:	58                   	pop    %eax
80104ff2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104ff5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104ff8:	c9                   	leave  
80104ff9:	c3                   	ret    

80104ffa <cli>:
{
80104ffa:	55                   	push   %ebp
80104ffb:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104ffd:	fa                   	cli    
}
80104ffe:	90                   	nop
80104fff:	5d                   	pop    %ebp
80105000:	c3                   	ret    

80105001 <sti>:
{
80105001:	55                   	push   %ebp
80105002:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105004:	fb                   	sti    
}
80105005:	90                   	nop
80105006:	5d                   	pop    %ebp
80105007:	c3                   	ret    

80105008 <xchg>:
{
80105008:	55                   	push   %ebp
80105009:	89 e5                	mov    %esp,%ebp
8010500b:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
8010500e:	8b 55 08             	mov    0x8(%ebp),%edx
80105011:	8b 45 0c             	mov    0xc(%ebp),%eax
80105014:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105017:	f0 87 02             	lock xchg %eax,(%edx)
8010501a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
8010501d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105020:	c9                   	leave  
80105021:	c3                   	ret    

80105022 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105022:	55                   	push   %ebp
80105023:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105025:	8b 45 08             	mov    0x8(%ebp),%eax
80105028:	8b 55 0c             	mov    0xc(%ebp),%edx
8010502b:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
8010502e:	8b 45 08             	mov    0x8(%ebp),%eax
80105031:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105037:	8b 45 08             	mov    0x8(%ebp),%eax
8010503a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105041:	90                   	nop
80105042:	5d                   	pop    %ebp
80105043:	c3                   	ret    

80105044 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105044:	55                   	push   %ebp
80105045:	89 e5                	mov    %esp,%ebp
80105047:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
8010504a:	e8 52 01 00 00       	call   801051a1 <pushcli>
  if(holding(lk))
8010504f:	8b 45 08             	mov    0x8(%ebp),%eax
80105052:	83 ec 0c             	sub    $0xc,%esp
80105055:	50                   	push   %eax
80105056:	e8 1c 01 00 00       	call   80105177 <holding>
8010505b:	83 c4 10             	add    $0x10,%esp
8010505e:	85 c0                	test   %eax,%eax
80105060:	74 0d                	je     8010506f <acquire+0x2b>
    panic("acquire");
80105062:	83 ec 0c             	sub    $0xc,%esp
80105065:	68 b9 89 10 80       	push   $0x801089b9
8010506a:	e8 f8 b4 ff ff       	call   80100567 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
8010506f:	90                   	nop
80105070:	8b 45 08             	mov    0x8(%ebp),%eax
80105073:	83 ec 08             	sub    $0x8,%esp
80105076:	6a 01                	push   $0x1
80105078:	50                   	push   %eax
80105079:	e8 8a ff ff ff       	call   80105008 <xchg>
8010507e:	83 c4 10             	add    $0x10,%esp
80105081:	85 c0                	test   %eax,%eax
80105083:	75 eb                	jne    80105070 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80105085:	8b 45 08             	mov    0x8(%ebp),%eax
80105088:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010508f:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105092:	8b 45 08             	mov    0x8(%ebp),%eax
80105095:	83 c0 0c             	add    $0xc,%eax
80105098:	83 ec 08             	sub    $0x8,%esp
8010509b:	50                   	push   %eax
8010509c:	8d 45 08             	lea    0x8(%ebp),%eax
8010509f:	50                   	push   %eax
801050a0:	e8 58 00 00 00       	call   801050fd <getcallerpcs>
801050a5:	83 c4 10             	add    $0x10,%esp
}
801050a8:	90                   	nop
801050a9:	c9                   	leave  
801050aa:	c3                   	ret    

801050ab <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801050ab:	55                   	push   %ebp
801050ac:	89 e5                	mov    %esp,%ebp
801050ae:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801050b1:	83 ec 0c             	sub    $0xc,%esp
801050b4:	ff 75 08             	pushl  0x8(%ebp)
801050b7:	e8 bb 00 00 00       	call   80105177 <holding>
801050bc:	83 c4 10             	add    $0x10,%esp
801050bf:	85 c0                	test   %eax,%eax
801050c1:	75 0d                	jne    801050d0 <release+0x25>
    panic("release");
801050c3:	83 ec 0c             	sub    $0xc,%esp
801050c6:	68 c1 89 10 80       	push   $0x801089c1
801050cb:	e8 97 b4 ff ff       	call   80100567 <panic>

  lk->pcs[0] = 0;
801050d0:	8b 45 08             	mov    0x8(%ebp),%eax
801050d3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801050da:	8b 45 08             	mov    0x8(%ebp),%eax
801050dd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
801050e4:	8b 45 08             	mov    0x8(%ebp),%eax
801050e7:	83 ec 08             	sub    $0x8,%esp
801050ea:	6a 00                	push   $0x0
801050ec:	50                   	push   %eax
801050ed:	e8 16 ff ff ff       	call   80105008 <xchg>
801050f2:	83 c4 10             	add    $0x10,%esp

  popcli();
801050f5:	e8 ec 00 00 00       	call   801051e6 <popcli>
}
801050fa:	90                   	nop
801050fb:	c9                   	leave  
801050fc:	c3                   	ret    

801050fd <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801050fd:	55                   	push   %ebp
801050fe:	89 e5                	mov    %esp,%ebp
80105100:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105103:	8b 45 08             	mov    0x8(%ebp),%eax
80105106:	83 e8 08             	sub    $0x8,%eax
80105109:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010510c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105113:	eb 38                	jmp    8010514d <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105115:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105119:	74 53                	je     8010516e <getcallerpcs+0x71>
8010511b:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105122:	76 4a                	jbe    8010516e <getcallerpcs+0x71>
80105124:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105128:	74 44                	je     8010516e <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010512a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010512d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105134:	8b 45 0c             	mov    0xc(%ebp),%eax
80105137:	01 c2                	add    %eax,%edx
80105139:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010513c:	8b 40 04             	mov    0x4(%eax),%eax
8010513f:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105141:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105144:	8b 00                	mov    (%eax),%eax
80105146:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105149:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010514d:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105151:	7e c2                	jle    80105115 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
80105153:	eb 19                	jmp    8010516e <getcallerpcs+0x71>
    pcs[i] = 0;
80105155:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105158:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010515f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105162:	01 d0                	add    %edx,%eax
80105164:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010516a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010516e:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105172:	7e e1                	jle    80105155 <getcallerpcs+0x58>
}
80105174:	90                   	nop
80105175:	c9                   	leave  
80105176:	c3                   	ret    

80105177 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105177:	55                   	push   %ebp
80105178:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
8010517a:	8b 45 08             	mov    0x8(%ebp),%eax
8010517d:	8b 00                	mov    (%eax),%eax
8010517f:	85 c0                	test   %eax,%eax
80105181:	74 17                	je     8010519a <holding+0x23>
80105183:	8b 45 08             	mov    0x8(%ebp),%eax
80105186:	8b 50 08             	mov    0x8(%eax),%edx
80105189:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010518f:	39 c2                	cmp    %eax,%edx
80105191:	75 07                	jne    8010519a <holding+0x23>
80105193:	b8 01 00 00 00       	mov    $0x1,%eax
80105198:	eb 05                	jmp    8010519f <holding+0x28>
8010519a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010519f:	5d                   	pop    %ebp
801051a0:	c3                   	ret    

801051a1 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801051a1:	55                   	push   %ebp
801051a2:	89 e5                	mov    %esp,%ebp
801051a4:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801051a7:	e8 3e fe ff ff       	call   80104fea <readeflags>
801051ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801051af:	e8 46 fe ff ff       	call   80104ffa <cli>
  if(cpu->ncli++ == 0)
801051b4:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801051bb:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801051c1:	8d 48 01             	lea    0x1(%eax),%ecx
801051c4:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801051ca:	85 c0                	test   %eax,%eax
801051cc:	75 15                	jne    801051e3 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
801051ce:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801051d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
801051d7:	81 e2 00 02 00 00    	and    $0x200,%edx
801051dd:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801051e3:	90                   	nop
801051e4:	c9                   	leave  
801051e5:	c3                   	ret    

801051e6 <popcli>:

void
popcli(void)
{
801051e6:	55                   	push   %ebp
801051e7:	89 e5                	mov    %esp,%ebp
801051e9:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
801051ec:	e8 f9 fd ff ff       	call   80104fea <readeflags>
801051f1:	25 00 02 00 00       	and    $0x200,%eax
801051f6:	85 c0                	test   %eax,%eax
801051f8:	74 0d                	je     80105207 <popcli+0x21>
    panic("popcli - interruptible");
801051fa:	83 ec 0c             	sub    $0xc,%esp
801051fd:	68 c9 89 10 80       	push   $0x801089c9
80105202:	e8 60 b3 ff ff       	call   80100567 <panic>
  if(--cpu->ncli < 0)
80105207:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010520d:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105213:	83 ea 01             	sub    $0x1,%edx
80105216:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
8010521c:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105222:	85 c0                	test   %eax,%eax
80105224:	79 0d                	jns    80105233 <popcli+0x4d>
    panic("popcli");
80105226:	83 ec 0c             	sub    $0xc,%esp
80105229:	68 e0 89 10 80       	push   $0x801089e0
8010522e:	e8 34 b3 ff ff       	call   80100567 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105233:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105239:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010523f:	85 c0                	test   %eax,%eax
80105241:	75 15                	jne    80105258 <popcli+0x72>
80105243:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105249:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010524f:	85 c0                	test   %eax,%eax
80105251:	74 05                	je     80105258 <popcli+0x72>
    sti();
80105253:	e8 a9 fd ff ff       	call   80105001 <sti>
}
80105258:	90                   	nop
80105259:	c9                   	leave  
8010525a:	c3                   	ret    

8010525b <stosb>:
{
8010525b:	55                   	push   %ebp
8010525c:	89 e5                	mov    %esp,%ebp
8010525e:	57                   	push   %edi
8010525f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105260:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105263:	8b 55 10             	mov    0x10(%ebp),%edx
80105266:	8b 45 0c             	mov    0xc(%ebp),%eax
80105269:	89 cb                	mov    %ecx,%ebx
8010526b:	89 df                	mov    %ebx,%edi
8010526d:	89 d1                	mov    %edx,%ecx
8010526f:	fc                   	cld    
80105270:	f3 aa                	rep stos %al,%es:(%edi)
80105272:	89 ca                	mov    %ecx,%edx
80105274:	89 fb                	mov    %edi,%ebx
80105276:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105279:	89 55 10             	mov    %edx,0x10(%ebp)
}
8010527c:	90                   	nop
8010527d:	5b                   	pop    %ebx
8010527e:	5f                   	pop    %edi
8010527f:	5d                   	pop    %ebp
80105280:	c3                   	ret    

80105281 <stosl>:
{
80105281:	55                   	push   %ebp
80105282:	89 e5                	mov    %esp,%ebp
80105284:	57                   	push   %edi
80105285:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105286:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105289:	8b 55 10             	mov    0x10(%ebp),%edx
8010528c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010528f:	89 cb                	mov    %ecx,%ebx
80105291:	89 df                	mov    %ebx,%edi
80105293:	89 d1                	mov    %edx,%ecx
80105295:	fc                   	cld    
80105296:	f3 ab                	rep stos %eax,%es:(%edi)
80105298:	89 ca                	mov    %ecx,%edx
8010529a:	89 fb                	mov    %edi,%ebx
8010529c:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010529f:	89 55 10             	mov    %edx,0x10(%ebp)
}
801052a2:	90                   	nop
801052a3:	5b                   	pop    %ebx
801052a4:	5f                   	pop    %edi
801052a5:	5d                   	pop    %ebp
801052a6:	c3                   	ret    

801052a7 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801052a7:	55                   	push   %ebp
801052a8:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
801052aa:	8b 45 08             	mov    0x8(%ebp),%eax
801052ad:	83 e0 03             	and    $0x3,%eax
801052b0:	85 c0                	test   %eax,%eax
801052b2:	75 43                	jne    801052f7 <memset+0x50>
801052b4:	8b 45 10             	mov    0x10(%ebp),%eax
801052b7:	83 e0 03             	and    $0x3,%eax
801052ba:	85 c0                	test   %eax,%eax
801052bc:	75 39                	jne    801052f7 <memset+0x50>
    c &= 0xFF;
801052be:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801052c5:	8b 45 10             	mov    0x10(%ebp),%eax
801052c8:	c1 e8 02             	shr    $0x2,%eax
801052cb:	89 c1                	mov    %eax,%ecx
801052cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801052d0:	c1 e0 18             	shl    $0x18,%eax
801052d3:	89 c2                	mov    %eax,%edx
801052d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801052d8:	c1 e0 10             	shl    $0x10,%eax
801052db:	09 c2                	or     %eax,%edx
801052dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801052e0:	c1 e0 08             	shl    $0x8,%eax
801052e3:	09 d0                	or     %edx,%eax
801052e5:	0b 45 0c             	or     0xc(%ebp),%eax
801052e8:	51                   	push   %ecx
801052e9:	50                   	push   %eax
801052ea:	ff 75 08             	pushl  0x8(%ebp)
801052ed:	e8 8f ff ff ff       	call   80105281 <stosl>
801052f2:	83 c4 0c             	add    $0xc,%esp
801052f5:	eb 12                	jmp    80105309 <memset+0x62>
  } else
    stosb(dst, c, n);
801052f7:	8b 45 10             	mov    0x10(%ebp),%eax
801052fa:	50                   	push   %eax
801052fb:	ff 75 0c             	pushl  0xc(%ebp)
801052fe:	ff 75 08             	pushl  0x8(%ebp)
80105301:	e8 55 ff ff ff       	call   8010525b <stosb>
80105306:	83 c4 0c             	add    $0xc,%esp
  return dst;
80105309:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010530c:	c9                   	leave  
8010530d:	c3                   	ret    

8010530e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
8010530e:	55                   	push   %ebp
8010530f:	89 e5                	mov    %esp,%ebp
80105311:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105314:	8b 45 08             	mov    0x8(%ebp),%eax
80105317:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
8010531a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010531d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105320:	eb 30                	jmp    80105352 <memcmp+0x44>
    if(*s1 != *s2)
80105322:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105325:	0f b6 10             	movzbl (%eax),%edx
80105328:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010532b:	0f b6 00             	movzbl (%eax),%eax
8010532e:	38 c2                	cmp    %al,%dl
80105330:	74 18                	je     8010534a <memcmp+0x3c>
      return *s1 - *s2;
80105332:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105335:	0f b6 00             	movzbl (%eax),%eax
80105338:	0f b6 d0             	movzbl %al,%edx
8010533b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010533e:	0f b6 00             	movzbl (%eax),%eax
80105341:	0f b6 c0             	movzbl %al,%eax
80105344:	29 c2                	sub    %eax,%edx
80105346:	89 d0                	mov    %edx,%eax
80105348:	eb 1a                	jmp    80105364 <memcmp+0x56>
    s1++, s2++;
8010534a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010534e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
80105352:	8b 45 10             	mov    0x10(%ebp),%eax
80105355:	8d 50 ff             	lea    -0x1(%eax),%edx
80105358:	89 55 10             	mov    %edx,0x10(%ebp)
8010535b:	85 c0                	test   %eax,%eax
8010535d:	75 c3                	jne    80105322 <memcmp+0x14>
  }

  return 0;
8010535f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105364:	c9                   	leave  
80105365:	c3                   	ret    

80105366 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105366:	55                   	push   %ebp
80105367:	89 e5                	mov    %esp,%ebp
80105369:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
8010536c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010536f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105372:	8b 45 08             	mov    0x8(%ebp),%eax
80105375:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105378:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010537b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010537e:	73 54                	jae    801053d4 <memmove+0x6e>
80105380:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105383:	8b 45 10             	mov    0x10(%ebp),%eax
80105386:	01 d0                	add    %edx,%eax
80105388:	39 45 f8             	cmp    %eax,-0x8(%ebp)
8010538b:	73 47                	jae    801053d4 <memmove+0x6e>
    s += n;
8010538d:	8b 45 10             	mov    0x10(%ebp),%eax
80105390:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105393:	8b 45 10             	mov    0x10(%ebp),%eax
80105396:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105399:	eb 13                	jmp    801053ae <memmove+0x48>
      *--d = *--s;
8010539b:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010539f:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801053a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053a6:	0f b6 10             	movzbl (%eax),%edx
801053a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053ac:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
801053ae:	8b 45 10             	mov    0x10(%ebp),%eax
801053b1:	8d 50 ff             	lea    -0x1(%eax),%edx
801053b4:	89 55 10             	mov    %edx,0x10(%ebp)
801053b7:	85 c0                	test   %eax,%eax
801053b9:	75 e0                	jne    8010539b <memmove+0x35>
  if(s < d && s + n > d){
801053bb:	eb 24                	jmp    801053e1 <memmove+0x7b>
  } else
    while(n-- > 0)
      *d++ = *s++;
801053bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
801053c0:	8d 42 01             	lea    0x1(%edx),%eax
801053c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
801053c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053c9:	8d 48 01             	lea    0x1(%eax),%ecx
801053cc:	89 4d f8             	mov    %ecx,-0x8(%ebp)
801053cf:	0f b6 12             	movzbl (%edx),%edx
801053d2:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
801053d4:	8b 45 10             	mov    0x10(%ebp),%eax
801053d7:	8d 50 ff             	lea    -0x1(%eax),%edx
801053da:	89 55 10             	mov    %edx,0x10(%ebp)
801053dd:	85 c0                	test   %eax,%eax
801053df:	75 dc                	jne    801053bd <memmove+0x57>

  return dst;
801053e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
801053e4:	c9                   	leave  
801053e5:	c3                   	ret    

801053e6 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801053e6:	55                   	push   %ebp
801053e7:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
801053e9:	ff 75 10             	pushl  0x10(%ebp)
801053ec:	ff 75 0c             	pushl  0xc(%ebp)
801053ef:	ff 75 08             	pushl  0x8(%ebp)
801053f2:	e8 6f ff ff ff       	call   80105366 <memmove>
801053f7:	83 c4 0c             	add    $0xc,%esp
}
801053fa:	c9                   	leave  
801053fb:	c3                   	ret    

801053fc <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801053fc:	55                   	push   %ebp
801053fd:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801053ff:	eb 0c                	jmp    8010540d <strncmp+0x11>
    n--, p++, q++;
80105401:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105405:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105409:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
8010540d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105411:	74 1a                	je     8010542d <strncmp+0x31>
80105413:	8b 45 08             	mov    0x8(%ebp),%eax
80105416:	0f b6 00             	movzbl (%eax),%eax
80105419:	84 c0                	test   %al,%al
8010541b:	74 10                	je     8010542d <strncmp+0x31>
8010541d:	8b 45 08             	mov    0x8(%ebp),%eax
80105420:	0f b6 10             	movzbl (%eax),%edx
80105423:	8b 45 0c             	mov    0xc(%ebp),%eax
80105426:	0f b6 00             	movzbl (%eax),%eax
80105429:	38 c2                	cmp    %al,%dl
8010542b:	74 d4                	je     80105401 <strncmp+0x5>
  if(n == 0)
8010542d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105431:	75 07                	jne    8010543a <strncmp+0x3e>
    return 0;
80105433:	b8 00 00 00 00       	mov    $0x0,%eax
80105438:	eb 16                	jmp    80105450 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
8010543a:	8b 45 08             	mov    0x8(%ebp),%eax
8010543d:	0f b6 00             	movzbl (%eax),%eax
80105440:	0f b6 d0             	movzbl %al,%edx
80105443:	8b 45 0c             	mov    0xc(%ebp),%eax
80105446:	0f b6 00             	movzbl (%eax),%eax
80105449:	0f b6 c0             	movzbl %al,%eax
8010544c:	29 c2                	sub    %eax,%edx
8010544e:	89 d0                	mov    %edx,%eax
}
80105450:	5d                   	pop    %ebp
80105451:	c3                   	ret    

80105452 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105452:	55                   	push   %ebp
80105453:	89 e5                	mov    %esp,%ebp
80105455:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105458:	8b 45 08             	mov    0x8(%ebp),%eax
8010545b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010545e:	90                   	nop
8010545f:	8b 45 10             	mov    0x10(%ebp),%eax
80105462:	8d 50 ff             	lea    -0x1(%eax),%edx
80105465:	89 55 10             	mov    %edx,0x10(%ebp)
80105468:	85 c0                	test   %eax,%eax
8010546a:	7e 2c                	jle    80105498 <strncpy+0x46>
8010546c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010546f:	8d 42 01             	lea    0x1(%edx),%eax
80105472:	89 45 0c             	mov    %eax,0xc(%ebp)
80105475:	8b 45 08             	mov    0x8(%ebp),%eax
80105478:	8d 48 01             	lea    0x1(%eax),%ecx
8010547b:	89 4d 08             	mov    %ecx,0x8(%ebp)
8010547e:	0f b6 12             	movzbl (%edx),%edx
80105481:	88 10                	mov    %dl,(%eax)
80105483:	0f b6 00             	movzbl (%eax),%eax
80105486:	84 c0                	test   %al,%al
80105488:	75 d5                	jne    8010545f <strncpy+0xd>
    ;
  while(n-- > 0)
8010548a:	eb 0c                	jmp    80105498 <strncpy+0x46>
    *s++ = 0;
8010548c:	8b 45 08             	mov    0x8(%ebp),%eax
8010548f:	8d 50 01             	lea    0x1(%eax),%edx
80105492:	89 55 08             	mov    %edx,0x8(%ebp)
80105495:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
80105498:	8b 45 10             	mov    0x10(%ebp),%eax
8010549b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010549e:	89 55 10             	mov    %edx,0x10(%ebp)
801054a1:	85 c0                	test   %eax,%eax
801054a3:	7f e7                	jg     8010548c <strncpy+0x3a>
  return os;
801054a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801054a8:	c9                   	leave  
801054a9:	c3                   	ret    

801054aa <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801054aa:	55                   	push   %ebp
801054ab:	89 e5                	mov    %esp,%ebp
801054ad:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801054b0:	8b 45 08             	mov    0x8(%ebp),%eax
801054b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801054b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801054ba:	7f 05                	jg     801054c1 <safestrcpy+0x17>
    return os;
801054bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054bf:	eb 31                	jmp    801054f2 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801054c1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801054c5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801054c9:	7e 1e                	jle    801054e9 <safestrcpy+0x3f>
801054cb:	8b 55 0c             	mov    0xc(%ebp),%edx
801054ce:	8d 42 01             	lea    0x1(%edx),%eax
801054d1:	89 45 0c             	mov    %eax,0xc(%ebp)
801054d4:	8b 45 08             	mov    0x8(%ebp),%eax
801054d7:	8d 48 01             	lea    0x1(%eax),%ecx
801054da:	89 4d 08             	mov    %ecx,0x8(%ebp)
801054dd:	0f b6 12             	movzbl (%edx),%edx
801054e0:	88 10                	mov    %dl,(%eax)
801054e2:	0f b6 00             	movzbl (%eax),%eax
801054e5:	84 c0                	test   %al,%al
801054e7:	75 d8                	jne    801054c1 <safestrcpy+0x17>
    ;
  *s = 0;
801054e9:	8b 45 08             	mov    0x8(%ebp),%eax
801054ec:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801054ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801054f2:	c9                   	leave  
801054f3:	c3                   	ret    

801054f4 <strlen>:

int
strlen(const char *s)
{
801054f4:	55                   	push   %ebp
801054f5:	89 e5                	mov    %esp,%ebp
801054f7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801054fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105501:	eb 04                	jmp    80105507 <strlen+0x13>
80105503:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105507:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010550a:	8b 45 08             	mov    0x8(%ebp),%eax
8010550d:	01 d0                	add    %edx,%eax
8010550f:	0f b6 00             	movzbl (%eax),%eax
80105512:	84 c0                	test   %al,%al
80105514:	75 ed                	jne    80105503 <strlen+0xf>
    ;
  return n;
80105516:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105519:	c9                   	leave  
8010551a:	c3                   	ret    

8010551b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010551b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010551f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105523:	55                   	push   %ebp
  pushl %ebx
80105524:	53                   	push   %ebx
  pushl %esi
80105525:	56                   	push   %esi
  pushl %edi
80105526:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105527:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105529:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010552b:	5f                   	pop    %edi
  popl %esi
8010552c:	5e                   	pop    %esi
  popl %ebx
8010552d:	5b                   	pop    %ebx
  popl %ebp
8010552e:	5d                   	pop    %ebp
  ret
8010552f:	c3                   	ret    

80105530 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105533:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105539:	8b 00                	mov    (%eax),%eax
8010553b:	39 45 08             	cmp    %eax,0x8(%ebp)
8010553e:	73 12                	jae    80105552 <fetchint+0x22>
80105540:	8b 45 08             	mov    0x8(%ebp),%eax
80105543:	8d 50 04             	lea    0x4(%eax),%edx
80105546:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010554c:	8b 00                	mov    (%eax),%eax
8010554e:	39 c2                	cmp    %eax,%edx
80105550:	76 07                	jbe    80105559 <fetchint+0x29>
    return -1;
80105552:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105557:	eb 0f                	jmp    80105568 <fetchint+0x38>
  *ip = *(int*)(addr);
80105559:	8b 45 08             	mov    0x8(%ebp),%eax
8010555c:	8b 10                	mov    (%eax),%edx
8010555e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105561:	89 10                	mov    %edx,(%eax)
  return 0;
80105563:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105568:	5d                   	pop    %ebp
80105569:	c3                   	ret    

8010556a <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
8010556a:	55                   	push   %ebp
8010556b:	89 e5                	mov    %esp,%ebp
8010556d:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105570:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105576:	8b 00                	mov    (%eax),%eax
80105578:	39 45 08             	cmp    %eax,0x8(%ebp)
8010557b:	72 07                	jb     80105584 <fetchstr+0x1a>
    return -1;
8010557d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105582:	eb 46                	jmp    801055ca <fetchstr+0x60>
  *pp = (char*)addr;
80105584:	8b 55 08             	mov    0x8(%ebp),%edx
80105587:	8b 45 0c             	mov    0xc(%ebp),%eax
8010558a:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
8010558c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105592:	8b 00                	mov    (%eax),%eax
80105594:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105597:	8b 45 0c             	mov    0xc(%ebp),%eax
8010559a:	8b 00                	mov    (%eax),%eax
8010559c:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010559f:	eb 1c                	jmp    801055bd <fetchstr+0x53>
    if(*s == 0)
801055a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055a4:	0f b6 00             	movzbl (%eax),%eax
801055a7:	84 c0                	test   %al,%al
801055a9:	75 0e                	jne    801055b9 <fetchstr+0x4f>
      return s - *pp;
801055ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801055ae:	8b 00                	mov    (%eax),%eax
801055b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
801055b3:	29 c2                	sub    %eax,%edx
801055b5:	89 d0                	mov    %edx,%eax
801055b7:	eb 11                	jmp    801055ca <fetchstr+0x60>
  for(s = *pp; s < ep; s++)
801055b9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801055bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055c0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801055c3:	72 dc                	jb     801055a1 <fetchstr+0x37>
  return -1;
801055c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055ca:	c9                   	leave  
801055cb:	c3                   	ret    

801055cc <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801055cc:	55                   	push   %ebp
801055cd:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801055cf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055d5:	8b 40 18             	mov    0x18(%eax),%eax
801055d8:	8b 40 44             	mov    0x44(%eax),%eax
801055db:	8b 55 08             	mov    0x8(%ebp),%edx
801055de:	c1 e2 02             	shl    $0x2,%edx
801055e1:	01 d0                	add    %edx,%eax
801055e3:	83 c0 04             	add    $0x4,%eax
801055e6:	ff 75 0c             	pushl  0xc(%ebp)
801055e9:	50                   	push   %eax
801055ea:	e8 41 ff ff ff       	call   80105530 <fetchint>
801055ef:	83 c4 08             	add    $0x8,%esp
}
801055f2:	c9                   	leave  
801055f3:	c3                   	ret    

801055f4 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801055f4:	55                   	push   %ebp
801055f5:	89 e5                	mov    %esp,%ebp
801055f7:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
801055fa:	8d 45 fc             	lea    -0x4(%ebp),%eax
801055fd:	50                   	push   %eax
801055fe:	ff 75 08             	pushl  0x8(%ebp)
80105601:	e8 c6 ff ff ff       	call   801055cc <argint>
80105606:	83 c4 08             	add    $0x8,%esp
80105609:	85 c0                	test   %eax,%eax
8010560b:	79 07                	jns    80105614 <argptr+0x20>
    return -1;
8010560d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105612:	eb 3b                	jmp    8010564f <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105614:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010561a:	8b 00                	mov    (%eax),%eax
8010561c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010561f:	39 d0                	cmp    %edx,%eax
80105621:	76 16                	jbe    80105639 <argptr+0x45>
80105623:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105626:	89 c2                	mov    %eax,%edx
80105628:	8b 45 10             	mov    0x10(%ebp),%eax
8010562b:	01 c2                	add    %eax,%edx
8010562d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105633:	8b 00                	mov    (%eax),%eax
80105635:	39 c2                	cmp    %eax,%edx
80105637:	76 07                	jbe    80105640 <argptr+0x4c>
    return -1;
80105639:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010563e:	eb 0f                	jmp    8010564f <argptr+0x5b>
  *pp = (char*)i;
80105640:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105643:	89 c2                	mov    %eax,%edx
80105645:	8b 45 0c             	mov    0xc(%ebp),%eax
80105648:	89 10                	mov    %edx,(%eax)
  return 0;
8010564a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010564f:	c9                   	leave  
80105650:	c3                   	ret    

80105651 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105651:	55                   	push   %ebp
80105652:	89 e5                	mov    %esp,%ebp
80105654:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105657:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010565a:	50                   	push   %eax
8010565b:	ff 75 08             	pushl  0x8(%ebp)
8010565e:	e8 69 ff ff ff       	call   801055cc <argint>
80105663:	83 c4 08             	add    $0x8,%esp
80105666:	85 c0                	test   %eax,%eax
80105668:	79 07                	jns    80105671 <argstr+0x20>
    return -1;
8010566a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010566f:	eb 0f                	jmp    80105680 <argstr+0x2f>
  return fetchstr(addr, pp);
80105671:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105674:	ff 75 0c             	pushl  0xc(%ebp)
80105677:	50                   	push   %eax
80105678:	e8 ed fe ff ff       	call   8010556a <fetchstr>
8010567d:	83 c4 08             	add    $0x8,%esp
}
80105680:	c9                   	leave  
80105681:	c3                   	ret    

80105682 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105682:	55                   	push   %ebp
80105683:	89 e5                	mov    %esp,%ebp
80105685:	83 ec 18             	sub    $0x18,%esp
  int num;

  num = proc->tf->eax;
80105688:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010568e:	8b 40 18             	mov    0x18(%eax),%eax
80105691:	8b 40 1c             	mov    0x1c(%eax),%eax
80105694:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105697:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010569b:	7e 32                	jle    801056cf <syscall+0x4d>
8010569d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056a0:	83 f8 15             	cmp    $0x15,%eax
801056a3:	77 2a                	ja     801056cf <syscall+0x4d>
801056a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056a8:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801056af:	85 c0                	test   %eax,%eax
801056b1:	74 1c                	je     801056cf <syscall+0x4d>
    proc->tf->eax = syscalls[num]();
801056b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056b6:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801056bd:	ff d0                	call   *%eax
801056bf:	89 c2                	mov    %eax,%edx
801056c1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056c7:	8b 40 18             	mov    0x18(%eax),%eax
801056ca:	89 50 1c             	mov    %edx,0x1c(%eax)
801056cd:	eb 34                	jmp    80105703 <syscall+0x81>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
801056cf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056d5:	8d 50 6c             	lea    0x6c(%eax),%edx
801056d8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("%d %s: unknown sys call %d\n",
801056de:	8b 40 10             	mov    0x10(%eax),%eax
801056e1:	ff 75 f4             	pushl  -0xc(%ebp)
801056e4:	52                   	push   %edx
801056e5:	50                   	push   %eax
801056e6:	68 e7 89 10 80       	push   $0x801089e7
801056eb:	e8 d4 ac ff ff       	call   801003c4 <cprintf>
801056f0:	83 c4 10             	add    $0x10,%esp
    proc->tf->eax = -1;
801056f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056f9:	8b 40 18             	mov    0x18(%eax),%eax
801056fc:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105703:	90                   	nop
80105704:	c9                   	leave  
80105705:	c3                   	ret    

80105706 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105706:	55                   	push   %ebp
80105707:	89 e5                	mov    %esp,%ebp
80105709:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010570c:	83 ec 08             	sub    $0x8,%esp
8010570f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105712:	50                   	push   %eax
80105713:	ff 75 08             	pushl  0x8(%ebp)
80105716:	e8 b1 fe ff ff       	call   801055cc <argint>
8010571b:	83 c4 10             	add    $0x10,%esp
8010571e:	85 c0                	test   %eax,%eax
80105720:	79 07                	jns    80105729 <argfd+0x23>
    return -1;
80105722:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105727:	eb 50                	jmp    80105779 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105729:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010572c:	85 c0                	test   %eax,%eax
8010572e:	78 21                	js     80105751 <argfd+0x4b>
80105730:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105733:	83 f8 0f             	cmp    $0xf,%eax
80105736:	7f 19                	jg     80105751 <argfd+0x4b>
80105738:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010573e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105741:	83 c2 08             	add    $0x8,%edx
80105744:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105748:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010574b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010574f:	75 07                	jne    80105758 <argfd+0x52>
    return -1;
80105751:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105756:	eb 21                	jmp    80105779 <argfd+0x73>
  if(pfd)
80105758:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010575c:	74 08                	je     80105766 <argfd+0x60>
    *pfd = fd;
8010575e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105761:	8b 45 0c             	mov    0xc(%ebp),%eax
80105764:	89 10                	mov    %edx,(%eax)
  if(pf)
80105766:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010576a:	74 08                	je     80105774 <argfd+0x6e>
    *pf = f;
8010576c:	8b 45 10             	mov    0x10(%ebp),%eax
8010576f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105772:	89 10                	mov    %edx,(%eax)
  return 0;
80105774:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105779:	c9                   	leave  
8010577a:	c3                   	ret    

8010577b <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010577b:	55                   	push   %ebp
8010577c:	89 e5                	mov    %esp,%ebp
8010577e:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105781:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105788:	eb 30                	jmp    801057ba <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
8010578a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105790:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105793:	83 c2 08             	add    $0x8,%edx
80105796:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010579a:	85 c0                	test   %eax,%eax
8010579c:	75 18                	jne    801057b6 <fdalloc+0x3b>
      proc->ofile[fd] = f;
8010579e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
801057a7:	8d 4a 08             	lea    0x8(%edx),%ecx
801057aa:	8b 55 08             	mov    0x8(%ebp),%edx
801057ad:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801057b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801057b4:	eb 0f                	jmp    801057c5 <fdalloc+0x4a>
  for(fd = 0; fd < NOFILE; fd++){
801057b6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801057ba:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801057be:	7e ca                	jle    8010578a <fdalloc+0xf>
    }
  }
  return -1;
801057c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057c5:	c9                   	leave  
801057c6:	c3                   	ret    

801057c7 <sys_dup>:

int
sys_dup(void)
{
801057c7:	55                   	push   %ebp
801057c8:	89 e5                	mov    %esp,%ebp
801057ca:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
801057cd:	83 ec 04             	sub    $0x4,%esp
801057d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057d3:	50                   	push   %eax
801057d4:	6a 00                	push   $0x0
801057d6:	6a 00                	push   $0x0
801057d8:	e8 29 ff ff ff       	call   80105706 <argfd>
801057dd:	83 c4 10             	add    $0x10,%esp
801057e0:	85 c0                	test   %eax,%eax
801057e2:	79 07                	jns    801057eb <sys_dup+0x24>
    return -1;
801057e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057e9:	eb 31                	jmp    8010581c <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801057eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057ee:	83 ec 0c             	sub    $0xc,%esp
801057f1:	50                   	push   %eax
801057f2:	e8 84 ff ff ff       	call   8010577b <fdalloc>
801057f7:	83 c4 10             	add    $0x10,%esp
801057fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
801057fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105801:	79 07                	jns    8010580a <sys_dup+0x43>
    return -1;
80105803:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105808:	eb 12                	jmp    8010581c <sys_dup+0x55>
  filedup(f);
8010580a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010580d:	83 ec 0c             	sub    $0xc,%esp
80105810:	50                   	push   %eax
80105811:	e8 f5 b7 ff ff       	call   8010100b <filedup>
80105816:	83 c4 10             	add    $0x10,%esp
  return fd;
80105819:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010581c:	c9                   	leave  
8010581d:	c3                   	ret    

8010581e <sys_read>:

int
sys_read(void)
{
8010581e:	55                   	push   %ebp
8010581f:	89 e5                	mov    %esp,%ebp
80105821:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105824:	83 ec 04             	sub    $0x4,%esp
80105827:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010582a:	50                   	push   %eax
8010582b:	6a 00                	push   $0x0
8010582d:	6a 00                	push   $0x0
8010582f:	e8 d2 fe ff ff       	call   80105706 <argfd>
80105834:	83 c4 10             	add    $0x10,%esp
80105837:	85 c0                	test   %eax,%eax
80105839:	78 2e                	js     80105869 <sys_read+0x4b>
8010583b:	83 ec 08             	sub    $0x8,%esp
8010583e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105841:	50                   	push   %eax
80105842:	6a 02                	push   $0x2
80105844:	e8 83 fd ff ff       	call   801055cc <argint>
80105849:	83 c4 10             	add    $0x10,%esp
8010584c:	85 c0                	test   %eax,%eax
8010584e:	78 19                	js     80105869 <sys_read+0x4b>
80105850:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105853:	83 ec 04             	sub    $0x4,%esp
80105856:	50                   	push   %eax
80105857:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010585a:	50                   	push   %eax
8010585b:	6a 01                	push   $0x1
8010585d:	e8 92 fd ff ff       	call   801055f4 <argptr>
80105862:	83 c4 10             	add    $0x10,%esp
80105865:	85 c0                	test   %eax,%eax
80105867:	79 07                	jns    80105870 <sys_read+0x52>
    return -1;
80105869:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010586e:	eb 17                	jmp    80105887 <sys_read+0x69>
  return fileread(f, p, n);
80105870:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105873:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105876:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105879:	83 ec 04             	sub    $0x4,%esp
8010587c:	51                   	push   %ecx
8010587d:	52                   	push   %edx
8010587e:	50                   	push   %eax
8010587f:	e8 17 b9 ff ff       	call   8010119b <fileread>
80105884:	83 c4 10             	add    $0x10,%esp
}
80105887:	c9                   	leave  
80105888:	c3                   	ret    

80105889 <sys_write>:

int
sys_write(void)
{
80105889:	55                   	push   %ebp
8010588a:	89 e5                	mov    %esp,%ebp
8010588c:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010588f:	83 ec 04             	sub    $0x4,%esp
80105892:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105895:	50                   	push   %eax
80105896:	6a 00                	push   $0x0
80105898:	6a 00                	push   $0x0
8010589a:	e8 67 fe ff ff       	call   80105706 <argfd>
8010589f:	83 c4 10             	add    $0x10,%esp
801058a2:	85 c0                	test   %eax,%eax
801058a4:	78 2e                	js     801058d4 <sys_write+0x4b>
801058a6:	83 ec 08             	sub    $0x8,%esp
801058a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058ac:	50                   	push   %eax
801058ad:	6a 02                	push   $0x2
801058af:	e8 18 fd ff ff       	call   801055cc <argint>
801058b4:	83 c4 10             	add    $0x10,%esp
801058b7:	85 c0                	test   %eax,%eax
801058b9:	78 19                	js     801058d4 <sys_write+0x4b>
801058bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058be:	83 ec 04             	sub    $0x4,%esp
801058c1:	50                   	push   %eax
801058c2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058c5:	50                   	push   %eax
801058c6:	6a 01                	push   $0x1
801058c8:	e8 27 fd ff ff       	call   801055f4 <argptr>
801058cd:	83 c4 10             	add    $0x10,%esp
801058d0:	85 c0                	test   %eax,%eax
801058d2:	79 07                	jns    801058db <sys_write+0x52>
    return -1;
801058d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d9:	eb 17                	jmp    801058f2 <sys_write+0x69>
  return filewrite(f, p, n);
801058db:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801058de:	8b 55 ec             	mov    -0x14(%ebp),%edx
801058e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058e4:	83 ec 04             	sub    $0x4,%esp
801058e7:	51                   	push   %ecx
801058e8:	52                   	push   %edx
801058e9:	50                   	push   %eax
801058ea:	e8 64 b9 ff ff       	call   80101253 <filewrite>
801058ef:	83 c4 10             	add    $0x10,%esp
}
801058f2:	c9                   	leave  
801058f3:	c3                   	ret    

801058f4 <sys_close>:

int
sys_close(void)
{
801058f4:	55                   	push   %ebp
801058f5:	89 e5                	mov    %esp,%ebp
801058f7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
801058fa:	83 ec 04             	sub    $0x4,%esp
801058fd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105900:	50                   	push   %eax
80105901:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105904:	50                   	push   %eax
80105905:	6a 00                	push   $0x0
80105907:	e8 fa fd ff ff       	call   80105706 <argfd>
8010590c:	83 c4 10             	add    $0x10,%esp
8010590f:	85 c0                	test   %eax,%eax
80105911:	79 07                	jns    8010591a <sys_close+0x26>
    return -1;
80105913:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105918:	eb 28                	jmp    80105942 <sys_close+0x4e>
  proc->ofile[fd] = 0;
8010591a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105920:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105923:	83 c2 08             	add    $0x8,%edx
80105926:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010592d:	00 
  fileclose(f);
8010592e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105931:	83 ec 0c             	sub    $0xc,%esp
80105934:	50                   	push   %eax
80105935:	e8 22 b7 ff ff       	call   8010105c <fileclose>
8010593a:	83 c4 10             	add    $0x10,%esp
  return 0;
8010593d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105942:	c9                   	leave  
80105943:	c3                   	ret    

80105944 <sys_fstat>:

int
sys_fstat(void)
{
80105944:	55                   	push   %ebp
80105945:	89 e5                	mov    %esp,%ebp
80105947:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010594a:	83 ec 04             	sub    $0x4,%esp
8010594d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105950:	50                   	push   %eax
80105951:	6a 00                	push   $0x0
80105953:	6a 00                	push   $0x0
80105955:	e8 ac fd ff ff       	call   80105706 <argfd>
8010595a:	83 c4 10             	add    $0x10,%esp
8010595d:	85 c0                	test   %eax,%eax
8010595f:	78 17                	js     80105978 <sys_fstat+0x34>
80105961:	83 ec 04             	sub    $0x4,%esp
80105964:	6a 14                	push   $0x14
80105966:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105969:	50                   	push   %eax
8010596a:	6a 01                	push   $0x1
8010596c:	e8 83 fc ff ff       	call   801055f4 <argptr>
80105971:	83 c4 10             	add    $0x10,%esp
80105974:	85 c0                	test   %eax,%eax
80105976:	79 07                	jns    8010597f <sys_fstat+0x3b>
    return -1;
80105978:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010597d:	eb 13                	jmp    80105992 <sys_fstat+0x4e>
  return filestat(f, st);
8010597f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105982:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105985:	83 ec 08             	sub    $0x8,%esp
80105988:	52                   	push   %edx
80105989:	50                   	push   %eax
8010598a:	e8 b5 b7 ff ff       	call   80101144 <filestat>
8010598f:	83 c4 10             	add    $0x10,%esp
}
80105992:	c9                   	leave  
80105993:	c3                   	ret    

80105994 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105994:	55                   	push   %ebp
80105995:	89 e5                	mov    %esp,%ebp
80105997:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010599a:	83 ec 08             	sub    $0x8,%esp
8010599d:	8d 45 d8             	lea    -0x28(%ebp),%eax
801059a0:	50                   	push   %eax
801059a1:	6a 00                	push   $0x0
801059a3:	e8 a9 fc ff ff       	call   80105651 <argstr>
801059a8:	83 c4 10             	add    $0x10,%esp
801059ab:	85 c0                	test   %eax,%eax
801059ad:	78 15                	js     801059c4 <sys_link+0x30>
801059af:	83 ec 08             	sub    $0x8,%esp
801059b2:	8d 45 dc             	lea    -0x24(%ebp),%eax
801059b5:	50                   	push   %eax
801059b6:	6a 01                	push   $0x1
801059b8:	e8 94 fc ff ff       	call   80105651 <argstr>
801059bd:	83 c4 10             	add    $0x10,%esp
801059c0:	85 c0                	test   %eax,%eax
801059c2:	79 0a                	jns    801059ce <sys_link+0x3a>
    return -1;
801059c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059c9:	e9 68 01 00 00       	jmp    80105b36 <sys_link+0x1a2>

  begin_op();
801059ce:	e8 83 db ff ff       	call   80103556 <begin_op>
  if((ip = namei(old)) == 0){
801059d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
801059d6:	83 ec 0c             	sub    $0xc,%esp
801059d9:	50                   	push   %eax
801059da:	e8 4b cb ff ff       	call   8010252a <namei>
801059df:	83 c4 10             	add    $0x10,%esp
801059e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801059e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059e9:	75 0f                	jne    801059fa <sys_link+0x66>
    end_op();
801059eb:	e8 f2 db ff ff       	call   801035e2 <end_op>
    return -1;
801059f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059f5:	e9 3c 01 00 00       	jmp    80105b36 <sys_link+0x1a2>
  }

  ilock(ip);
801059fa:	83 ec 0c             	sub    $0xc,%esp
801059fd:	ff 75 f4             	pushl  -0xc(%ebp)
80105a00:	e8 70 bf ff ff       	call   80101975 <ilock>
80105a05:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a0b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105a0f:	66 83 f8 01          	cmp    $0x1,%ax
80105a13:	75 1d                	jne    80105a32 <sys_link+0x9e>
    iunlockput(ip);
80105a15:	83 ec 0c             	sub    $0xc,%esp
80105a18:	ff 75 f4             	pushl  -0xc(%ebp)
80105a1b:	e8 15 c2 ff ff       	call   80101c35 <iunlockput>
80105a20:	83 c4 10             	add    $0x10,%esp
    end_op();
80105a23:	e8 ba db ff ff       	call   801035e2 <end_op>
    return -1;
80105a28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a2d:	e9 04 01 00 00       	jmp    80105b36 <sys_link+0x1a2>
  }

  ip->nlink++;
80105a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a35:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105a39:	83 c0 01             	add    $0x1,%eax
80105a3c:	89 c2                	mov    %eax,%edx
80105a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a41:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105a45:	83 ec 0c             	sub    $0xc,%esp
80105a48:	ff 75 f4             	pushl  -0xc(%ebp)
80105a4b:	e8 4b bd ff ff       	call   8010179b <iupdate>
80105a50:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105a53:	83 ec 0c             	sub    $0xc,%esp
80105a56:	ff 75 f4             	pushl  -0xc(%ebp)
80105a59:	e8 75 c0 ff ff       	call   80101ad3 <iunlock>
80105a5e:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105a61:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a64:	83 ec 08             	sub    $0x8,%esp
80105a67:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105a6a:	52                   	push   %edx
80105a6b:	50                   	push   %eax
80105a6c:	e8 d5 ca ff ff       	call   80102546 <nameiparent>
80105a71:	83 c4 10             	add    $0x10,%esp
80105a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105a77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a7b:	74 71                	je     80105aee <sys_link+0x15a>
    goto bad;
  ilock(dp);
80105a7d:	83 ec 0c             	sub    $0xc,%esp
80105a80:	ff 75 f0             	pushl  -0x10(%ebp)
80105a83:	e8 ed be ff ff       	call   80101975 <ilock>
80105a88:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a8e:	8b 10                	mov    (%eax),%edx
80105a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a93:	8b 00                	mov    (%eax),%eax
80105a95:	39 c2                	cmp    %eax,%edx
80105a97:	75 1d                	jne    80105ab6 <sys_link+0x122>
80105a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a9c:	8b 40 04             	mov    0x4(%eax),%eax
80105a9f:	83 ec 04             	sub    $0x4,%esp
80105aa2:	50                   	push   %eax
80105aa3:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105aa6:	50                   	push   %eax
80105aa7:	ff 75 f0             	pushl  -0x10(%ebp)
80105aaa:	e8 e3 c7 ff ff       	call   80102292 <dirlink>
80105aaf:	83 c4 10             	add    $0x10,%esp
80105ab2:	85 c0                	test   %eax,%eax
80105ab4:	79 10                	jns    80105ac6 <sys_link+0x132>
    iunlockput(dp);
80105ab6:	83 ec 0c             	sub    $0xc,%esp
80105ab9:	ff 75 f0             	pushl  -0x10(%ebp)
80105abc:	e8 74 c1 ff ff       	call   80101c35 <iunlockput>
80105ac1:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105ac4:	eb 29                	jmp    80105aef <sys_link+0x15b>
  }
  iunlockput(dp);
80105ac6:	83 ec 0c             	sub    $0xc,%esp
80105ac9:	ff 75 f0             	pushl  -0x10(%ebp)
80105acc:	e8 64 c1 ff ff       	call   80101c35 <iunlockput>
80105ad1:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105ad4:	83 ec 0c             	sub    $0xc,%esp
80105ad7:	ff 75 f4             	pushl  -0xc(%ebp)
80105ada:	e8 66 c0 ff ff       	call   80101b45 <iput>
80105adf:	83 c4 10             	add    $0x10,%esp

  end_op();
80105ae2:	e8 fb da ff ff       	call   801035e2 <end_op>

  return 0;
80105ae7:	b8 00 00 00 00       	mov    $0x0,%eax
80105aec:	eb 48                	jmp    80105b36 <sys_link+0x1a2>
    goto bad;
80105aee:	90                   	nop

bad:
  ilock(ip);
80105aef:	83 ec 0c             	sub    $0xc,%esp
80105af2:	ff 75 f4             	pushl  -0xc(%ebp)
80105af5:	e8 7b be ff ff       	call   80101975 <ilock>
80105afa:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b00:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105b04:	83 e8 01             	sub    $0x1,%eax
80105b07:	89 c2                	mov    %eax,%edx
80105b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b0c:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105b10:	83 ec 0c             	sub    $0xc,%esp
80105b13:	ff 75 f4             	pushl  -0xc(%ebp)
80105b16:	e8 80 bc ff ff       	call   8010179b <iupdate>
80105b1b:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105b1e:	83 ec 0c             	sub    $0xc,%esp
80105b21:	ff 75 f4             	pushl  -0xc(%ebp)
80105b24:	e8 0c c1 ff ff       	call   80101c35 <iunlockput>
80105b29:	83 c4 10             	add    $0x10,%esp
  end_op();
80105b2c:	e8 b1 da ff ff       	call   801035e2 <end_op>
  return -1;
80105b31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b36:	c9                   	leave  
80105b37:	c3                   	ret    

80105b38 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105b38:	55                   	push   %ebp
80105b39:	89 e5                	mov    %esp,%ebp
80105b3b:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105b3e:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105b45:	eb 40                	jmp    80105b87 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b4a:	6a 10                	push   $0x10
80105b4c:	50                   	push   %eax
80105b4d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b50:	50                   	push   %eax
80105b51:	ff 75 08             	pushl  0x8(%ebp)
80105b54:	e8 85 c3 ff ff       	call   80101ede <readi>
80105b59:	83 c4 10             	add    $0x10,%esp
80105b5c:	83 f8 10             	cmp    $0x10,%eax
80105b5f:	74 0d                	je     80105b6e <isdirempty+0x36>
      panic("isdirempty: readi");
80105b61:	83 ec 0c             	sub    $0xc,%esp
80105b64:	68 03 8a 10 80       	push   $0x80108a03
80105b69:	e8 f9 a9 ff ff       	call   80100567 <panic>
    if(de.inum != 0)
80105b6e:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105b72:	66 85 c0             	test   %ax,%ax
80105b75:	74 07                	je     80105b7e <isdirempty+0x46>
      return 0;
80105b77:	b8 00 00 00 00       	mov    $0x0,%eax
80105b7c:	eb 1b                	jmp    80105b99 <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b81:	83 c0 10             	add    $0x10,%eax
80105b84:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b87:	8b 45 08             	mov    0x8(%ebp),%eax
80105b8a:	8b 50 18             	mov    0x18(%eax),%edx
80105b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b90:	39 c2                	cmp    %eax,%edx
80105b92:	77 b3                	ja     80105b47 <isdirempty+0xf>
  }
  return 1;
80105b94:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105b99:	c9                   	leave  
80105b9a:	c3                   	ret    

80105b9b <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105b9b:	55                   	push   %ebp
80105b9c:	89 e5                	mov    %esp,%ebp
80105b9e:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105ba1:	83 ec 08             	sub    $0x8,%esp
80105ba4:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105ba7:	50                   	push   %eax
80105ba8:	6a 00                	push   $0x0
80105baa:	e8 a2 fa ff ff       	call   80105651 <argstr>
80105baf:	83 c4 10             	add    $0x10,%esp
80105bb2:	85 c0                	test   %eax,%eax
80105bb4:	79 0a                	jns    80105bc0 <sys_unlink+0x25>
    return -1;
80105bb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bbb:	e9 bf 01 00 00       	jmp    80105d7f <sys_unlink+0x1e4>

  begin_op();
80105bc0:	e8 91 d9 ff ff       	call   80103556 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105bc5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105bc8:	83 ec 08             	sub    $0x8,%esp
80105bcb:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105bce:	52                   	push   %edx
80105bcf:	50                   	push   %eax
80105bd0:	e8 71 c9 ff ff       	call   80102546 <nameiparent>
80105bd5:	83 c4 10             	add    $0x10,%esp
80105bd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105bdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105bdf:	75 0f                	jne    80105bf0 <sys_unlink+0x55>
    end_op();
80105be1:	e8 fc d9 ff ff       	call   801035e2 <end_op>
    return -1;
80105be6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105beb:	e9 8f 01 00 00       	jmp    80105d7f <sys_unlink+0x1e4>
  }

  ilock(dp);
80105bf0:	83 ec 0c             	sub    $0xc,%esp
80105bf3:	ff 75 f4             	pushl  -0xc(%ebp)
80105bf6:	e8 7a bd ff ff       	call   80101975 <ilock>
80105bfb:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105bfe:	83 ec 08             	sub    $0x8,%esp
80105c01:	68 15 8a 10 80       	push   $0x80108a15
80105c06:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105c09:	50                   	push   %eax
80105c0a:	e8 ae c5 ff ff       	call   801021bd <namecmp>
80105c0f:	83 c4 10             	add    $0x10,%esp
80105c12:	85 c0                	test   %eax,%eax
80105c14:	0f 84 49 01 00 00    	je     80105d63 <sys_unlink+0x1c8>
80105c1a:	83 ec 08             	sub    $0x8,%esp
80105c1d:	68 17 8a 10 80       	push   $0x80108a17
80105c22:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105c25:	50                   	push   %eax
80105c26:	e8 92 c5 ff ff       	call   801021bd <namecmp>
80105c2b:	83 c4 10             	add    $0x10,%esp
80105c2e:	85 c0                	test   %eax,%eax
80105c30:	0f 84 2d 01 00 00    	je     80105d63 <sys_unlink+0x1c8>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105c36:	83 ec 04             	sub    $0x4,%esp
80105c39:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105c3c:	50                   	push   %eax
80105c3d:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105c40:	50                   	push   %eax
80105c41:	ff 75 f4             	pushl  -0xc(%ebp)
80105c44:	e8 8f c5 ff ff       	call   801021d8 <dirlookup>
80105c49:	83 c4 10             	add    $0x10,%esp
80105c4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c53:	0f 84 0d 01 00 00    	je     80105d66 <sys_unlink+0x1cb>
    goto bad;
  ilock(ip);
80105c59:	83 ec 0c             	sub    $0xc,%esp
80105c5c:	ff 75 f0             	pushl  -0x10(%ebp)
80105c5f:	e8 11 bd ff ff       	call   80101975 <ilock>
80105c64:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c6a:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105c6e:	66 85 c0             	test   %ax,%ax
80105c71:	7f 0d                	jg     80105c80 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80105c73:	83 ec 0c             	sub    $0xc,%esp
80105c76:	68 1a 8a 10 80       	push   $0x80108a1a
80105c7b:	e8 e7 a8 ff ff       	call   80100567 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105c80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c83:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105c87:	66 83 f8 01          	cmp    $0x1,%ax
80105c8b:	75 25                	jne    80105cb2 <sys_unlink+0x117>
80105c8d:	83 ec 0c             	sub    $0xc,%esp
80105c90:	ff 75 f0             	pushl  -0x10(%ebp)
80105c93:	e8 a0 fe ff ff       	call   80105b38 <isdirempty>
80105c98:	83 c4 10             	add    $0x10,%esp
80105c9b:	85 c0                	test   %eax,%eax
80105c9d:	75 13                	jne    80105cb2 <sys_unlink+0x117>
    iunlockput(ip);
80105c9f:	83 ec 0c             	sub    $0xc,%esp
80105ca2:	ff 75 f0             	pushl  -0x10(%ebp)
80105ca5:	e8 8b bf ff ff       	call   80101c35 <iunlockput>
80105caa:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105cad:	e9 b5 00 00 00       	jmp    80105d67 <sys_unlink+0x1cc>
  }

  memset(&de, 0, sizeof(de));
80105cb2:	83 ec 04             	sub    $0x4,%esp
80105cb5:	6a 10                	push   $0x10
80105cb7:	6a 00                	push   $0x0
80105cb9:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105cbc:	50                   	push   %eax
80105cbd:	e8 e5 f5 ff ff       	call   801052a7 <memset>
80105cc2:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105cc5:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105cc8:	6a 10                	push   $0x10
80105cca:	50                   	push   %eax
80105ccb:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105cce:	50                   	push   %eax
80105ccf:	ff 75 f4             	pushl  -0xc(%ebp)
80105cd2:	e8 5e c3 ff ff       	call   80102035 <writei>
80105cd7:	83 c4 10             	add    $0x10,%esp
80105cda:	83 f8 10             	cmp    $0x10,%eax
80105cdd:	74 0d                	je     80105cec <sys_unlink+0x151>
    panic("unlink: writei");
80105cdf:	83 ec 0c             	sub    $0xc,%esp
80105ce2:	68 2c 8a 10 80       	push   $0x80108a2c
80105ce7:	e8 7b a8 ff ff       	call   80100567 <panic>
  if(ip->type == T_DIR){
80105cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cef:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105cf3:	66 83 f8 01          	cmp    $0x1,%ax
80105cf7:	75 21                	jne    80105d1a <sys_unlink+0x17f>
    dp->nlink--;
80105cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cfc:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105d00:	83 e8 01             	sub    $0x1,%eax
80105d03:	89 c2                	mov    %eax,%edx
80105d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d08:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105d0c:	83 ec 0c             	sub    $0xc,%esp
80105d0f:	ff 75 f4             	pushl  -0xc(%ebp)
80105d12:	e8 84 ba ff ff       	call   8010179b <iupdate>
80105d17:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105d1a:	83 ec 0c             	sub    $0xc,%esp
80105d1d:	ff 75 f4             	pushl  -0xc(%ebp)
80105d20:	e8 10 bf ff ff       	call   80101c35 <iunlockput>
80105d25:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105d28:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d2b:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105d2f:	83 e8 01             	sub    $0x1,%eax
80105d32:	89 c2                	mov    %eax,%edx
80105d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d37:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105d3b:	83 ec 0c             	sub    $0xc,%esp
80105d3e:	ff 75 f0             	pushl  -0x10(%ebp)
80105d41:	e8 55 ba ff ff       	call   8010179b <iupdate>
80105d46:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105d49:	83 ec 0c             	sub    $0xc,%esp
80105d4c:	ff 75 f0             	pushl  -0x10(%ebp)
80105d4f:	e8 e1 be ff ff       	call   80101c35 <iunlockput>
80105d54:	83 c4 10             	add    $0x10,%esp

  end_op();
80105d57:	e8 86 d8 ff ff       	call   801035e2 <end_op>

  return 0;
80105d5c:	b8 00 00 00 00       	mov    $0x0,%eax
80105d61:	eb 1c                	jmp    80105d7f <sys_unlink+0x1e4>
    goto bad;
80105d63:	90                   	nop
80105d64:	eb 01                	jmp    80105d67 <sys_unlink+0x1cc>
    goto bad;
80105d66:	90                   	nop

bad:
  iunlockput(dp);
80105d67:	83 ec 0c             	sub    $0xc,%esp
80105d6a:	ff 75 f4             	pushl  -0xc(%ebp)
80105d6d:	e8 c3 be ff ff       	call   80101c35 <iunlockput>
80105d72:	83 c4 10             	add    $0x10,%esp
  end_op();
80105d75:	e8 68 d8 ff ff       	call   801035e2 <end_op>
  return -1;
80105d7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d7f:	c9                   	leave  
80105d80:	c3                   	ret    

80105d81 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105d81:	55                   	push   %ebp
80105d82:	89 e5                	mov    %esp,%ebp
80105d84:	83 ec 38             	sub    $0x38,%esp
80105d87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105d8a:	8b 55 10             	mov    0x10(%ebp),%edx
80105d8d:	8b 45 14             	mov    0x14(%ebp),%eax
80105d90:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105d94:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105d98:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105d9c:	83 ec 08             	sub    $0x8,%esp
80105d9f:	8d 45 de             	lea    -0x22(%ebp),%eax
80105da2:	50                   	push   %eax
80105da3:	ff 75 08             	pushl  0x8(%ebp)
80105da6:	e8 9b c7 ff ff       	call   80102546 <nameiparent>
80105dab:	83 c4 10             	add    $0x10,%esp
80105dae:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105db1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105db5:	75 0a                	jne    80105dc1 <create+0x40>
    return 0;
80105db7:	b8 00 00 00 00       	mov    $0x0,%eax
80105dbc:	e9 90 01 00 00       	jmp    80105f51 <create+0x1d0>
  ilock(dp);
80105dc1:	83 ec 0c             	sub    $0xc,%esp
80105dc4:	ff 75 f4             	pushl  -0xc(%ebp)
80105dc7:	e8 a9 bb ff ff       	call   80101975 <ilock>
80105dcc:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80105dcf:	83 ec 04             	sub    $0x4,%esp
80105dd2:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105dd5:	50                   	push   %eax
80105dd6:	8d 45 de             	lea    -0x22(%ebp),%eax
80105dd9:	50                   	push   %eax
80105dda:	ff 75 f4             	pushl  -0xc(%ebp)
80105ddd:	e8 f6 c3 ff ff       	call   801021d8 <dirlookup>
80105de2:	83 c4 10             	add    $0x10,%esp
80105de5:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105de8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105dec:	74 50                	je     80105e3e <create+0xbd>
    iunlockput(dp);
80105dee:	83 ec 0c             	sub    $0xc,%esp
80105df1:	ff 75 f4             	pushl  -0xc(%ebp)
80105df4:	e8 3c be ff ff       	call   80101c35 <iunlockput>
80105df9:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105dfc:	83 ec 0c             	sub    $0xc,%esp
80105dff:	ff 75 f0             	pushl  -0x10(%ebp)
80105e02:	e8 6e bb ff ff       	call   80101975 <ilock>
80105e07:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80105e0a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105e0f:	75 15                	jne    80105e26 <create+0xa5>
80105e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e14:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105e18:	66 83 f8 02          	cmp    $0x2,%ax
80105e1c:	75 08                	jne    80105e26 <create+0xa5>
      return ip;
80105e1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e21:	e9 2b 01 00 00       	jmp    80105f51 <create+0x1d0>
    iunlockput(ip);
80105e26:	83 ec 0c             	sub    $0xc,%esp
80105e29:	ff 75 f0             	pushl  -0x10(%ebp)
80105e2c:	e8 04 be ff ff       	call   80101c35 <iunlockput>
80105e31:	83 c4 10             	add    $0x10,%esp
    return 0;
80105e34:	b8 00 00 00 00       	mov    $0x0,%eax
80105e39:	e9 13 01 00 00       	jmp    80105f51 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105e3e:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e45:	8b 00                	mov    (%eax),%eax
80105e47:	83 ec 08             	sub    $0x8,%esp
80105e4a:	52                   	push   %edx
80105e4b:	50                   	push   %eax
80105e4c:	e8 73 b8 ff ff       	call   801016c4 <ialloc>
80105e51:	83 c4 10             	add    $0x10,%esp
80105e54:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e5b:	75 0d                	jne    80105e6a <create+0xe9>
    panic("create: ialloc");
80105e5d:	83 ec 0c             	sub    $0xc,%esp
80105e60:	68 3b 8a 10 80       	push   $0x80108a3b
80105e65:	e8 fd a6 ff ff       	call   80100567 <panic>

  ilock(ip);
80105e6a:	83 ec 0c             	sub    $0xc,%esp
80105e6d:	ff 75 f0             	pushl  -0x10(%ebp)
80105e70:	e8 00 bb ff ff       	call   80101975 <ilock>
80105e75:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105e78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e7b:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105e7f:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105e83:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e86:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105e8a:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e91:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105e97:	83 ec 0c             	sub    $0xc,%esp
80105e9a:	ff 75 f0             	pushl  -0x10(%ebp)
80105e9d:	e8 f9 b8 ff ff       	call   8010179b <iupdate>
80105ea2:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80105ea5:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105eaa:	75 6a                	jne    80105f16 <create+0x195>
    dp->nlink++;  // for ".."
80105eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eaf:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105eb3:	83 c0 01             	add    $0x1,%eax
80105eb6:	89 c2                	mov    %eax,%edx
80105eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ebb:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105ebf:	83 ec 0c             	sub    $0xc,%esp
80105ec2:	ff 75 f4             	pushl  -0xc(%ebp)
80105ec5:	e8 d1 b8 ff ff       	call   8010179b <iupdate>
80105eca:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ed0:	8b 40 04             	mov    0x4(%eax),%eax
80105ed3:	83 ec 04             	sub    $0x4,%esp
80105ed6:	50                   	push   %eax
80105ed7:	68 15 8a 10 80       	push   $0x80108a15
80105edc:	ff 75 f0             	pushl  -0x10(%ebp)
80105edf:	e8 ae c3 ff ff       	call   80102292 <dirlink>
80105ee4:	83 c4 10             	add    $0x10,%esp
80105ee7:	85 c0                	test   %eax,%eax
80105ee9:	78 1e                	js     80105f09 <create+0x188>
80105eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eee:	8b 40 04             	mov    0x4(%eax),%eax
80105ef1:	83 ec 04             	sub    $0x4,%esp
80105ef4:	50                   	push   %eax
80105ef5:	68 17 8a 10 80       	push   $0x80108a17
80105efa:	ff 75 f0             	pushl  -0x10(%ebp)
80105efd:	e8 90 c3 ff ff       	call   80102292 <dirlink>
80105f02:	83 c4 10             	add    $0x10,%esp
80105f05:	85 c0                	test   %eax,%eax
80105f07:	79 0d                	jns    80105f16 <create+0x195>
      panic("create dots");
80105f09:	83 ec 0c             	sub    $0xc,%esp
80105f0c:	68 4a 8a 10 80       	push   $0x80108a4a
80105f11:	e8 51 a6 ff ff       	call   80100567 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f19:	8b 40 04             	mov    0x4(%eax),%eax
80105f1c:	83 ec 04             	sub    $0x4,%esp
80105f1f:	50                   	push   %eax
80105f20:	8d 45 de             	lea    -0x22(%ebp),%eax
80105f23:	50                   	push   %eax
80105f24:	ff 75 f4             	pushl  -0xc(%ebp)
80105f27:	e8 66 c3 ff ff       	call   80102292 <dirlink>
80105f2c:	83 c4 10             	add    $0x10,%esp
80105f2f:	85 c0                	test   %eax,%eax
80105f31:	79 0d                	jns    80105f40 <create+0x1bf>
    panic("create: dirlink");
80105f33:	83 ec 0c             	sub    $0xc,%esp
80105f36:	68 56 8a 10 80       	push   $0x80108a56
80105f3b:	e8 27 a6 ff ff       	call   80100567 <panic>

  iunlockput(dp);
80105f40:	83 ec 0c             	sub    $0xc,%esp
80105f43:	ff 75 f4             	pushl  -0xc(%ebp)
80105f46:	e8 ea bc ff ff       	call   80101c35 <iunlockput>
80105f4b:	83 c4 10             	add    $0x10,%esp

  return ip;
80105f4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105f51:	c9                   	leave  
80105f52:	c3                   	ret    

80105f53 <sys_open>:

int
sys_open(void)
{
80105f53:	55                   	push   %ebp
80105f54:	89 e5                	mov    %esp,%ebp
80105f56:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105f59:	83 ec 08             	sub    $0x8,%esp
80105f5c:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105f5f:	50                   	push   %eax
80105f60:	6a 00                	push   $0x0
80105f62:	e8 ea f6 ff ff       	call   80105651 <argstr>
80105f67:	83 c4 10             	add    $0x10,%esp
80105f6a:	85 c0                	test   %eax,%eax
80105f6c:	78 15                	js     80105f83 <sys_open+0x30>
80105f6e:	83 ec 08             	sub    $0x8,%esp
80105f71:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f74:	50                   	push   %eax
80105f75:	6a 01                	push   $0x1
80105f77:	e8 50 f6 ff ff       	call   801055cc <argint>
80105f7c:	83 c4 10             	add    $0x10,%esp
80105f7f:	85 c0                	test   %eax,%eax
80105f81:	79 0a                	jns    80105f8d <sys_open+0x3a>
    return -1;
80105f83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f88:	e9 61 01 00 00       	jmp    801060ee <sys_open+0x19b>

  begin_op();
80105f8d:	e8 c4 d5 ff ff       	call   80103556 <begin_op>

  if(omode & O_CREATE){
80105f92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f95:	25 00 02 00 00       	and    $0x200,%eax
80105f9a:	85 c0                	test   %eax,%eax
80105f9c:	74 2a                	je     80105fc8 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80105f9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105fa1:	6a 00                	push   $0x0
80105fa3:	6a 00                	push   $0x0
80105fa5:	6a 02                	push   $0x2
80105fa7:	50                   	push   %eax
80105fa8:	e8 d4 fd ff ff       	call   80105d81 <create>
80105fad:	83 c4 10             	add    $0x10,%esp
80105fb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105fb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fb7:	75 75                	jne    8010602e <sys_open+0xdb>
      end_op();
80105fb9:	e8 24 d6 ff ff       	call   801035e2 <end_op>
      return -1;
80105fbe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fc3:	e9 26 01 00 00       	jmp    801060ee <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80105fc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105fcb:	83 ec 0c             	sub    $0xc,%esp
80105fce:	50                   	push   %eax
80105fcf:	e8 56 c5 ff ff       	call   8010252a <namei>
80105fd4:	83 c4 10             	add    $0x10,%esp
80105fd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105fda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fde:	75 0f                	jne    80105fef <sys_open+0x9c>
      end_op();
80105fe0:	e8 fd d5 ff ff       	call   801035e2 <end_op>
      return -1;
80105fe5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fea:	e9 ff 00 00 00       	jmp    801060ee <sys_open+0x19b>
    }
    ilock(ip);
80105fef:	83 ec 0c             	sub    $0xc,%esp
80105ff2:	ff 75 f4             	pushl  -0xc(%ebp)
80105ff5:	e8 7b b9 ff ff       	call   80101975 <ilock>
80105ffa:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106000:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106004:	66 83 f8 01          	cmp    $0x1,%ax
80106008:	75 24                	jne    8010602e <sys_open+0xdb>
8010600a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010600d:	85 c0                	test   %eax,%eax
8010600f:	74 1d                	je     8010602e <sys_open+0xdb>
      iunlockput(ip);
80106011:	83 ec 0c             	sub    $0xc,%esp
80106014:	ff 75 f4             	pushl  -0xc(%ebp)
80106017:	e8 19 bc ff ff       	call   80101c35 <iunlockput>
8010601c:	83 c4 10             	add    $0x10,%esp
      end_op();
8010601f:	e8 be d5 ff ff       	call   801035e2 <end_op>
      return -1;
80106024:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106029:	e9 c0 00 00 00       	jmp    801060ee <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010602e:	e8 6b af ff ff       	call   80100f9e <filealloc>
80106033:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106036:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010603a:	74 17                	je     80106053 <sys_open+0x100>
8010603c:	83 ec 0c             	sub    $0xc,%esp
8010603f:	ff 75 f0             	pushl  -0x10(%ebp)
80106042:	e8 34 f7 ff ff       	call   8010577b <fdalloc>
80106047:	83 c4 10             	add    $0x10,%esp
8010604a:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010604d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106051:	79 2e                	jns    80106081 <sys_open+0x12e>
    if(f)
80106053:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106057:	74 0e                	je     80106067 <sys_open+0x114>
      fileclose(f);
80106059:	83 ec 0c             	sub    $0xc,%esp
8010605c:	ff 75 f0             	pushl  -0x10(%ebp)
8010605f:	e8 f8 af ff ff       	call   8010105c <fileclose>
80106064:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106067:	83 ec 0c             	sub    $0xc,%esp
8010606a:	ff 75 f4             	pushl  -0xc(%ebp)
8010606d:	e8 c3 bb ff ff       	call   80101c35 <iunlockput>
80106072:	83 c4 10             	add    $0x10,%esp
    end_op();
80106075:	e8 68 d5 ff ff       	call   801035e2 <end_op>
    return -1;
8010607a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010607f:	eb 6d                	jmp    801060ee <sys_open+0x19b>
  }
  iunlock(ip);
80106081:	83 ec 0c             	sub    $0xc,%esp
80106084:	ff 75 f4             	pushl  -0xc(%ebp)
80106087:	e8 47 ba ff ff       	call   80101ad3 <iunlock>
8010608c:	83 c4 10             	add    $0x10,%esp
  end_op();
8010608f:	e8 4e d5 ff ff       	call   801035e2 <end_op>

  f->type = FD_INODE;
80106094:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106097:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010609d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801060a3:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801060a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060a9:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801060b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060b3:	83 e0 01             	and    $0x1,%eax
801060b6:	85 c0                	test   %eax,%eax
801060b8:	0f 94 c0             	sete   %al
801060bb:	89 c2                	mov    %eax,%edx
801060bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060c0:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801060c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060c6:	83 e0 01             	and    $0x1,%eax
801060c9:	85 c0                	test   %eax,%eax
801060cb:	75 0a                	jne    801060d7 <sys_open+0x184>
801060cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060d0:	83 e0 02             	and    $0x2,%eax
801060d3:	85 c0                	test   %eax,%eax
801060d5:	74 07                	je     801060de <sys_open+0x18b>
801060d7:	b8 01 00 00 00       	mov    $0x1,%eax
801060dc:	eb 05                	jmp    801060e3 <sys_open+0x190>
801060de:	b8 00 00 00 00       	mov    $0x0,%eax
801060e3:	89 c2                	mov    %eax,%edx
801060e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060e8:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801060eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801060ee:	c9                   	leave  
801060ef:	c3                   	ret    

801060f0 <sys_mkdir>:

int
sys_mkdir(void)
{
801060f0:	55                   	push   %ebp
801060f1:	89 e5                	mov    %esp,%ebp
801060f3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801060f6:	e8 5b d4 ff ff       	call   80103556 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801060fb:	83 ec 08             	sub    $0x8,%esp
801060fe:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106101:	50                   	push   %eax
80106102:	6a 00                	push   $0x0
80106104:	e8 48 f5 ff ff       	call   80105651 <argstr>
80106109:	83 c4 10             	add    $0x10,%esp
8010610c:	85 c0                	test   %eax,%eax
8010610e:	78 1b                	js     8010612b <sys_mkdir+0x3b>
80106110:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106113:	6a 00                	push   $0x0
80106115:	6a 00                	push   $0x0
80106117:	6a 01                	push   $0x1
80106119:	50                   	push   %eax
8010611a:	e8 62 fc ff ff       	call   80105d81 <create>
8010611f:	83 c4 10             	add    $0x10,%esp
80106122:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106125:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106129:	75 0c                	jne    80106137 <sys_mkdir+0x47>
    end_op();
8010612b:	e8 b2 d4 ff ff       	call   801035e2 <end_op>
    return -1;
80106130:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106135:	eb 18                	jmp    8010614f <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80106137:	83 ec 0c             	sub    $0xc,%esp
8010613a:	ff 75 f4             	pushl  -0xc(%ebp)
8010613d:	e8 f3 ba ff ff       	call   80101c35 <iunlockput>
80106142:	83 c4 10             	add    $0x10,%esp
  end_op();
80106145:	e8 98 d4 ff ff       	call   801035e2 <end_op>
  return 0;
8010614a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010614f:	c9                   	leave  
80106150:	c3                   	ret    

80106151 <sys_mknod>:

int
sys_mknod(void)
{
80106151:	55                   	push   %ebp
80106152:	89 e5                	mov    %esp,%ebp
80106154:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80106157:	e8 fa d3 ff ff       	call   80103556 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
8010615c:	83 ec 08             	sub    $0x8,%esp
8010615f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106162:	50                   	push   %eax
80106163:	6a 00                	push   $0x0
80106165:	e8 e7 f4 ff ff       	call   80105651 <argstr>
8010616a:	83 c4 10             	add    $0x10,%esp
8010616d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106170:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106174:	78 4f                	js     801061c5 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80106176:	83 ec 08             	sub    $0x8,%esp
80106179:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010617c:	50                   	push   %eax
8010617d:	6a 01                	push   $0x1
8010617f:	e8 48 f4 ff ff       	call   801055cc <argint>
80106184:	83 c4 10             	add    $0x10,%esp
  if((len=argstr(0, &path)) < 0 ||
80106187:	85 c0                	test   %eax,%eax
80106189:	78 3a                	js     801061c5 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
8010618b:	83 ec 08             	sub    $0x8,%esp
8010618e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106191:	50                   	push   %eax
80106192:	6a 02                	push   $0x2
80106194:	e8 33 f4 ff ff       	call   801055cc <argint>
80106199:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
8010619c:	85 c0                	test   %eax,%eax
8010619e:	78 25                	js     801061c5 <sys_mknod+0x74>
     (ip = create(path, T_DEV, major, minor)) == 0){
801061a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801061a3:	0f bf c8             	movswl %ax,%ecx
801061a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801061a9:	0f bf d0             	movswl %ax,%edx
801061ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801061af:	51                   	push   %ecx
801061b0:	52                   	push   %edx
801061b1:	6a 03                	push   $0x3
801061b3:	50                   	push   %eax
801061b4:	e8 c8 fb ff ff       	call   80105d81 <create>
801061b9:	83 c4 10             	add    $0x10,%esp
801061bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
     argint(2, &minor) < 0 ||
801061bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801061c3:	75 0c                	jne    801061d1 <sys_mknod+0x80>
    end_op();
801061c5:	e8 18 d4 ff ff       	call   801035e2 <end_op>
    return -1;
801061ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061cf:	eb 18                	jmp    801061e9 <sys_mknod+0x98>
  }
  iunlockput(ip);
801061d1:	83 ec 0c             	sub    $0xc,%esp
801061d4:	ff 75 f0             	pushl  -0x10(%ebp)
801061d7:	e8 59 ba ff ff       	call   80101c35 <iunlockput>
801061dc:	83 c4 10             	add    $0x10,%esp
  end_op();
801061df:	e8 fe d3 ff ff       	call   801035e2 <end_op>
  return 0;
801061e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061e9:	c9                   	leave  
801061ea:	c3                   	ret    

801061eb <sys_chdir>:

int
sys_chdir(void)
{
801061eb:	55                   	push   %ebp
801061ec:	89 e5                	mov    %esp,%ebp
801061ee:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801061f1:	e8 60 d3 ff ff       	call   80103556 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801061f6:	83 ec 08             	sub    $0x8,%esp
801061f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061fc:	50                   	push   %eax
801061fd:	6a 00                	push   $0x0
801061ff:	e8 4d f4 ff ff       	call   80105651 <argstr>
80106204:	83 c4 10             	add    $0x10,%esp
80106207:	85 c0                	test   %eax,%eax
80106209:	78 18                	js     80106223 <sys_chdir+0x38>
8010620b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010620e:	83 ec 0c             	sub    $0xc,%esp
80106211:	50                   	push   %eax
80106212:	e8 13 c3 ff ff       	call   8010252a <namei>
80106217:	83 c4 10             	add    $0x10,%esp
8010621a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010621d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106221:	75 0c                	jne    8010622f <sys_chdir+0x44>
    end_op();
80106223:	e8 ba d3 ff ff       	call   801035e2 <end_op>
    return -1;
80106228:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010622d:	eb 6e                	jmp    8010629d <sys_chdir+0xb2>
  }
  ilock(ip);
8010622f:	83 ec 0c             	sub    $0xc,%esp
80106232:	ff 75 f4             	pushl  -0xc(%ebp)
80106235:	e8 3b b7 ff ff       	call   80101975 <ilock>
8010623a:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
8010623d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106240:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106244:	66 83 f8 01          	cmp    $0x1,%ax
80106248:	74 1a                	je     80106264 <sys_chdir+0x79>
    iunlockput(ip);
8010624a:	83 ec 0c             	sub    $0xc,%esp
8010624d:	ff 75 f4             	pushl  -0xc(%ebp)
80106250:	e8 e0 b9 ff ff       	call   80101c35 <iunlockput>
80106255:	83 c4 10             	add    $0x10,%esp
    end_op();
80106258:	e8 85 d3 ff ff       	call   801035e2 <end_op>
    return -1;
8010625d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106262:	eb 39                	jmp    8010629d <sys_chdir+0xb2>
  }
  iunlock(ip);
80106264:	83 ec 0c             	sub    $0xc,%esp
80106267:	ff 75 f4             	pushl  -0xc(%ebp)
8010626a:	e8 64 b8 ff ff       	call   80101ad3 <iunlock>
8010626f:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80106272:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106278:	8b 40 68             	mov    0x68(%eax),%eax
8010627b:	83 ec 0c             	sub    $0xc,%esp
8010627e:	50                   	push   %eax
8010627f:	e8 c1 b8 ff ff       	call   80101b45 <iput>
80106284:	83 c4 10             	add    $0x10,%esp
  end_op();
80106287:	e8 56 d3 ff ff       	call   801035e2 <end_op>
  proc->cwd = ip;
8010628c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106292:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106295:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106298:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010629d:	c9                   	leave  
8010629e:	c3                   	ret    

8010629f <sys_exec>:

int
sys_exec(void)
{
8010629f:	55                   	push   %ebp
801062a0:	89 e5                	mov    %esp,%ebp
801062a2:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801062a8:	83 ec 08             	sub    $0x8,%esp
801062ab:	8d 45 f0             	lea    -0x10(%ebp),%eax
801062ae:	50                   	push   %eax
801062af:	6a 00                	push   $0x0
801062b1:	e8 9b f3 ff ff       	call   80105651 <argstr>
801062b6:	83 c4 10             	add    $0x10,%esp
801062b9:	85 c0                	test   %eax,%eax
801062bb:	78 18                	js     801062d5 <sys_exec+0x36>
801062bd:	83 ec 08             	sub    $0x8,%esp
801062c0:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801062c6:	50                   	push   %eax
801062c7:	6a 01                	push   $0x1
801062c9:	e8 fe f2 ff ff       	call   801055cc <argint>
801062ce:	83 c4 10             	add    $0x10,%esp
801062d1:	85 c0                	test   %eax,%eax
801062d3:	79 0a                	jns    801062df <sys_exec+0x40>
    return -1;
801062d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062da:	e9 c6 00 00 00       	jmp    801063a5 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
801062df:	83 ec 04             	sub    $0x4,%esp
801062e2:	68 80 00 00 00       	push   $0x80
801062e7:	6a 00                	push   $0x0
801062e9:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801062ef:	50                   	push   %eax
801062f0:	e8 b2 ef ff ff       	call   801052a7 <memset>
801062f5:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
801062f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801062ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106302:	83 f8 1f             	cmp    $0x1f,%eax
80106305:	76 0a                	jbe    80106311 <sys_exec+0x72>
      return -1;
80106307:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010630c:	e9 94 00 00 00       	jmp    801063a5 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106311:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106314:	c1 e0 02             	shl    $0x2,%eax
80106317:	89 c2                	mov    %eax,%edx
80106319:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
8010631f:	01 c2                	add    %eax,%edx
80106321:	83 ec 08             	sub    $0x8,%esp
80106324:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010632a:	50                   	push   %eax
8010632b:	52                   	push   %edx
8010632c:	e8 ff f1 ff ff       	call   80105530 <fetchint>
80106331:	83 c4 10             	add    $0x10,%esp
80106334:	85 c0                	test   %eax,%eax
80106336:	79 07                	jns    8010633f <sys_exec+0xa0>
      return -1;
80106338:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010633d:	eb 66                	jmp    801063a5 <sys_exec+0x106>
    if(uarg == 0){
8010633f:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106345:	85 c0                	test   %eax,%eax
80106347:	75 27                	jne    80106370 <sys_exec+0xd1>
      argv[i] = 0;
80106349:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010634c:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106353:	00 00 00 00 
      break;
80106357:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106358:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010635b:	83 ec 08             	sub    $0x8,%esp
8010635e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106364:	52                   	push   %edx
80106365:	50                   	push   %eax
80106366:	e8 11 a8 ff ff       	call   80100b7c <exec>
8010636b:	83 c4 10             	add    $0x10,%esp
8010636e:	eb 35                	jmp    801063a5 <sys_exec+0x106>
    if(fetchstr(uarg, &argv[i]) < 0)
80106370:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106376:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106379:	c1 e2 02             	shl    $0x2,%edx
8010637c:	01 c2                	add    %eax,%edx
8010637e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106384:	83 ec 08             	sub    $0x8,%esp
80106387:	52                   	push   %edx
80106388:	50                   	push   %eax
80106389:	e8 dc f1 ff ff       	call   8010556a <fetchstr>
8010638e:	83 c4 10             	add    $0x10,%esp
80106391:	85 c0                	test   %eax,%eax
80106393:	79 07                	jns    8010639c <sys_exec+0xfd>
      return -1;
80106395:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010639a:	eb 09                	jmp    801063a5 <sys_exec+0x106>
  for(i=0;; i++){
8010639c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
801063a0:	e9 5a ff ff ff       	jmp    801062ff <sys_exec+0x60>
}
801063a5:	c9                   	leave  
801063a6:	c3                   	ret    

801063a7 <sys_pipe>:

int
sys_pipe(void)
{
801063a7:	55                   	push   %ebp
801063a8:	89 e5                	mov    %esp,%ebp
801063aa:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801063ad:	83 ec 04             	sub    $0x4,%esp
801063b0:	6a 08                	push   $0x8
801063b2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801063b5:	50                   	push   %eax
801063b6:	6a 00                	push   $0x0
801063b8:	e8 37 f2 ff ff       	call   801055f4 <argptr>
801063bd:	83 c4 10             	add    $0x10,%esp
801063c0:	85 c0                	test   %eax,%eax
801063c2:	79 0a                	jns    801063ce <sys_pipe+0x27>
    return -1;
801063c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063c9:	e9 af 00 00 00       	jmp    8010647d <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
801063ce:	83 ec 08             	sub    $0x8,%esp
801063d1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801063d4:	50                   	push   %eax
801063d5:	8d 45 e8             	lea    -0x18(%ebp),%eax
801063d8:	50                   	push   %eax
801063d9:	e8 78 dc ff ff       	call   80104056 <pipealloc>
801063de:	83 c4 10             	add    $0x10,%esp
801063e1:	85 c0                	test   %eax,%eax
801063e3:	79 0a                	jns    801063ef <sys_pipe+0x48>
    return -1;
801063e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063ea:	e9 8e 00 00 00       	jmp    8010647d <sys_pipe+0xd6>
  fd0 = -1;
801063ef:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801063f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801063f9:	83 ec 0c             	sub    $0xc,%esp
801063fc:	50                   	push   %eax
801063fd:	e8 79 f3 ff ff       	call   8010577b <fdalloc>
80106402:	83 c4 10             	add    $0x10,%esp
80106405:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106408:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010640c:	78 18                	js     80106426 <sys_pipe+0x7f>
8010640e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106411:	83 ec 0c             	sub    $0xc,%esp
80106414:	50                   	push   %eax
80106415:	e8 61 f3 ff ff       	call   8010577b <fdalloc>
8010641a:	83 c4 10             	add    $0x10,%esp
8010641d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106420:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106424:	79 3f                	jns    80106465 <sys_pipe+0xbe>
    if(fd0 >= 0)
80106426:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010642a:	78 14                	js     80106440 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
8010642c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106432:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106435:	83 c2 08             	add    $0x8,%edx
80106438:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010643f:	00 
    fileclose(rf);
80106440:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106443:	83 ec 0c             	sub    $0xc,%esp
80106446:	50                   	push   %eax
80106447:	e8 10 ac ff ff       	call   8010105c <fileclose>
8010644c:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
8010644f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106452:	83 ec 0c             	sub    $0xc,%esp
80106455:	50                   	push   %eax
80106456:	e8 01 ac ff ff       	call   8010105c <fileclose>
8010645b:	83 c4 10             	add    $0x10,%esp
    return -1;
8010645e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106463:	eb 18                	jmp    8010647d <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80106465:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106468:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010646b:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
8010646d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106470:	8d 50 04             	lea    0x4(%eax),%edx
80106473:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106476:	89 02                	mov    %eax,(%edx)
  return 0;
80106478:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010647d:	c9                   	leave  
8010647e:	c3                   	ret    

8010647f <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
8010647f:	55                   	push   %ebp
80106480:	89 e5                	mov    %esp,%ebp
80106482:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106485:	e8 cc e2 ff ff       	call   80104756 <fork>
}
8010648a:	c9                   	leave  
8010648b:	c3                   	ret    

8010648c <sys_exit>:

int
sys_exit(void)
{
8010648c:	55                   	push   %ebp
8010648d:	89 e5                	mov    %esp,%ebp
8010648f:	83 ec 08             	sub    $0x8,%esp
  exit();
80106492:	e8 52 e4 ff ff       	call   801048e9 <exit>
  return 0;  // not reached
80106497:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010649c:	c9                   	leave  
8010649d:	c3                   	ret    

8010649e <sys_wait>:

int
sys_wait(void)
{
8010649e:	55                   	push   %ebp
8010649f:	89 e5                	mov    %esp,%ebp
801064a1:	83 ec 08             	sub    $0x8,%esp
  return wait();
801064a4:	e8 78 e5 ff ff       	call   80104a21 <wait>
}
801064a9:	c9                   	leave  
801064aa:	c3                   	ret    

801064ab <sys_kill>:

int
sys_kill(void)
{
801064ab:	55                   	push   %ebp
801064ac:	89 e5                	mov    %esp,%ebp
801064ae:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
801064b1:	83 ec 08             	sub    $0x8,%esp
801064b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801064b7:	50                   	push   %eax
801064b8:	6a 00                	push   $0x0
801064ba:	e8 0d f1 ff ff       	call   801055cc <argint>
801064bf:	83 c4 10             	add    $0x10,%esp
801064c2:	85 c0                	test   %eax,%eax
801064c4:	79 07                	jns    801064cd <sys_kill+0x22>
    return -1;
801064c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064cb:	eb 0f                	jmp    801064dc <sys_kill+0x31>
  return kill(pid);
801064cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064d0:	83 ec 0c             	sub    $0xc,%esp
801064d3:	50                   	push   %eax
801064d4:	e8 94 e9 ff ff       	call   80104e6d <kill>
801064d9:	83 c4 10             	add    $0x10,%esp
}
801064dc:	c9                   	leave  
801064dd:	c3                   	ret    

801064de <sys_getpid>:

int
sys_getpid(void)
{
801064de:	55                   	push   %ebp
801064df:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801064e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064e7:	8b 40 10             	mov    0x10(%eax),%eax
}
801064ea:	5d                   	pop    %ebp
801064eb:	c3                   	ret    

801064ec <sys_sbrk>:

int
sys_sbrk(void)
{
801064ec:	55                   	push   %ebp
801064ed:	89 e5                	mov    %esp,%ebp
801064ef:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801064f2:	83 ec 08             	sub    $0x8,%esp
801064f5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064f8:	50                   	push   %eax
801064f9:	6a 00                	push   $0x0
801064fb:	e8 cc f0 ff ff       	call   801055cc <argint>
80106500:	83 c4 10             	add    $0x10,%esp
80106503:	85 c0                	test   %eax,%eax
80106505:	79 07                	jns    8010650e <sys_sbrk+0x22>
    return -1;
80106507:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010650c:	eb 28                	jmp    80106536 <sys_sbrk+0x4a>
  addr = proc->sz;
8010650e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106514:	8b 00                	mov    (%eax),%eax
80106516:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106519:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010651c:	83 ec 0c             	sub    $0xc,%esp
8010651f:	50                   	push   %eax
80106520:	e8 8e e1 ff ff       	call   801046b3 <growproc>
80106525:	83 c4 10             	add    $0x10,%esp
80106528:	85 c0                	test   %eax,%eax
8010652a:	79 07                	jns    80106533 <sys_sbrk+0x47>
    return -1;
8010652c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106531:	eb 03                	jmp    80106536 <sys_sbrk+0x4a>
  return addr;
80106533:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106536:	c9                   	leave  
80106537:	c3                   	ret    

80106538 <sys_sleep>:

int
sys_sleep(void)
{
80106538:	55                   	push   %ebp
80106539:	89 e5                	mov    %esp,%ebp
8010653b:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
8010653e:	83 ec 08             	sub    $0x8,%esp
80106541:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106544:	50                   	push   %eax
80106545:	6a 00                	push   $0x0
80106547:	e8 80 f0 ff ff       	call   801055cc <argint>
8010654c:	83 c4 10             	add    $0x10,%esp
8010654f:	85 c0                	test   %eax,%eax
80106551:	79 07                	jns    8010655a <sys_sleep+0x22>
    return -1;
80106553:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106558:	eb 77                	jmp    801065d1 <sys_sleep+0x99>
  acquire(&tickslock);
8010655a:	83 ec 0c             	sub    $0xc,%esp
8010655d:	68 a0 48 11 80       	push   $0x801148a0
80106562:	e8 dd ea ff ff       	call   80105044 <acquire>
80106567:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
8010656a:	a1 e0 50 11 80       	mov    0x801150e0,%eax
8010656f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106572:	eb 39                	jmp    801065ad <sys_sleep+0x75>
    if(proc->killed){
80106574:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010657a:	8b 40 24             	mov    0x24(%eax),%eax
8010657d:	85 c0                	test   %eax,%eax
8010657f:	74 17                	je     80106598 <sys_sleep+0x60>
      release(&tickslock);
80106581:	83 ec 0c             	sub    $0xc,%esp
80106584:	68 a0 48 11 80       	push   $0x801148a0
80106589:	e8 1d eb ff ff       	call   801050ab <release>
8010658e:	83 c4 10             	add    $0x10,%esp
      return -1;
80106591:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106596:	eb 39                	jmp    801065d1 <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
80106598:	83 ec 08             	sub    $0x8,%esp
8010659b:	68 a0 48 11 80       	push   $0x801148a0
801065a0:	68 e0 50 11 80       	push   $0x801150e0
801065a5:	e8 a1 e7 ff ff       	call   80104d4b <sleep>
801065aa:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
801065ad:	a1 e0 50 11 80       	mov    0x801150e0,%eax
801065b2:	2b 45 f4             	sub    -0xc(%ebp),%eax
801065b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801065b8:	39 d0                	cmp    %edx,%eax
801065ba:	72 b8                	jb     80106574 <sys_sleep+0x3c>
  }
  release(&tickslock);
801065bc:	83 ec 0c             	sub    $0xc,%esp
801065bf:	68 a0 48 11 80       	push   $0x801148a0
801065c4:	e8 e2 ea ff ff       	call   801050ab <release>
801065c9:	83 c4 10             	add    $0x10,%esp
  return 0;
801065cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801065d1:	c9                   	leave  
801065d2:	c3                   	ret    

801065d3 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801065d3:	55                   	push   %ebp
801065d4:	89 e5                	mov    %esp,%ebp
801065d6:	83 ec 18             	sub    $0x18,%esp
  uint xticks;
  
  acquire(&tickslock);
801065d9:	83 ec 0c             	sub    $0xc,%esp
801065dc:	68 a0 48 11 80       	push   $0x801148a0
801065e1:	e8 5e ea ff ff       	call   80105044 <acquire>
801065e6:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
801065e9:	a1 e0 50 11 80       	mov    0x801150e0,%eax
801065ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801065f1:	83 ec 0c             	sub    $0xc,%esp
801065f4:	68 a0 48 11 80       	push   $0x801148a0
801065f9:	e8 ad ea ff ff       	call   801050ab <release>
801065fe:	83 c4 10             	add    $0x10,%esp
  return xticks;
80106601:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106604:	c9                   	leave  
80106605:	c3                   	ret    

80106606 <outb>:
{
80106606:	55                   	push   %ebp
80106607:	89 e5                	mov    %esp,%ebp
80106609:	83 ec 08             	sub    $0x8,%esp
8010660c:	8b 45 08             	mov    0x8(%ebp),%eax
8010660f:	8b 55 0c             	mov    0xc(%ebp),%edx
80106612:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106616:	89 d0                	mov    %edx,%eax
80106618:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010661b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010661f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106623:	ee                   	out    %al,(%dx)
}
80106624:	90                   	nop
80106625:	c9                   	leave  
80106626:	c3                   	ret    

80106627 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106627:	55                   	push   %ebp
80106628:	89 e5                	mov    %esp,%ebp
8010662a:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
8010662d:	6a 34                	push   $0x34
8010662f:	6a 43                	push   $0x43
80106631:	e8 d0 ff ff ff       	call   80106606 <outb>
80106636:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106639:	68 9c 00 00 00       	push   $0x9c
8010663e:	6a 40                	push   $0x40
80106640:	e8 c1 ff ff ff       	call   80106606 <outb>
80106645:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106648:	6a 2e                	push   $0x2e
8010664a:	6a 40                	push   $0x40
8010664c:	e8 b5 ff ff ff       	call   80106606 <outb>
80106651:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80106654:	83 ec 0c             	sub    $0xc,%esp
80106657:	6a 00                	push   $0x0
80106659:	e8 e2 d8 ff ff       	call   80103f40 <picenable>
8010665e:	83 c4 10             	add    $0x10,%esp
}
80106661:	90                   	nop
80106662:	c9                   	leave  
80106663:	c3                   	ret    

80106664 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106664:	1e                   	push   %ds
  pushl %es
80106665:	06                   	push   %es
  pushl %fs
80106666:	0f a0                	push   %fs
  pushl %gs
80106668:	0f a8                	push   %gs
  pushal
8010666a:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
8010666b:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010666f:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106671:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106673:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106677:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106679:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
8010667b:	54                   	push   %esp
  call trap
8010667c:	e8 d7 01 00 00       	call   80106858 <trap>
  addl $4, %esp
80106681:	83 c4 04             	add    $0x4,%esp

80106684 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106684:	61                   	popa   
  popl %gs
80106685:	0f a9                	pop    %gs
  popl %fs
80106687:	0f a1                	pop    %fs
  popl %es
80106689:	07                   	pop    %es
  popl %ds
8010668a:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010668b:	83 c4 08             	add    $0x8,%esp
  iret
8010668e:	cf                   	iret   

8010668f <lidt>:
{
8010668f:	55                   	push   %ebp
80106690:	89 e5                	mov    %esp,%ebp
80106692:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106695:	8b 45 0c             	mov    0xc(%ebp),%eax
80106698:	83 e8 01             	sub    $0x1,%eax
8010669b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010669f:	8b 45 08             	mov    0x8(%ebp),%eax
801066a2:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801066a6:	8b 45 08             	mov    0x8(%ebp),%eax
801066a9:	c1 e8 10             	shr    $0x10,%eax
801066ac:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801066b0:	8d 45 fa             	lea    -0x6(%ebp),%eax
801066b3:	0f 01 18             	lidtl  (%eax)
}
801066b6:	90                   	nop
801066b7:	c9                   	leave  
801066b8:	c3                   	ret    

801066b9 <rcr2>:
{
801066b9:	55                   	push   %ebp
801066ba:	89 e5                	mov    %esp,%ebp
801066bc:	83 ec 10             	sub    $0x10,%esp
  asm volatile("movl %%cr2,%0" : "=r" (val));
801066bf:	0f 20 d0             	mov    %cr2,%eax
801066c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801066c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801066c8:	c9                   	leave  
801066c9:	c3                   	ret    

801066ca <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801066ca:	55                   	push   %ebp
801066cb:	89 e5                	mov    %esp,%ebp
801066cd:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
801066d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801066d7:	e9 c3 00 00 00       	jmp    8010679f <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801066dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066df:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
801066e6:	89 c2                	mov    %eax,%edx
801066e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066eb:	66 89 14 c5 e0 48 11 	mov    %dx,-0x7feeb720(,%eax,8)
801066f2:	80 
801066f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066f6:	66 c7 04 c5 e2 48 11 	movw   $0x8,-0x7feeb71e(,%eax,8)
801066fd:	80 08 00 
80106700:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106703:	0f b6 14 c5 e4 48 11 	movzbl -0x7feeb71c(,%eax,8),%edx
8010670a:	80 
8010670b:	83 e2 e0             	and    $0xffffffe0,%edx
8010670e:	88 14 c5 e4 48 11 80 	mov    %dl,-0x7feeb71c(,%eax,8)
80106715:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106718:	0f b6 14 c5 e4 48 11 	movzbl -0x7feeb71c(,%eax,8),%edx
8010671f:	80 
80106720:	83 e2 1f             	and    $0x1f,%edx
80106723:	88 14 c5 e4 48 11 80 	mov    %dl,-0x7feeb71c(,%eax,8)
8010672a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010672d:	0f b6 14 c5 e5 48 11 	movzbl -0x7feeb71b(,%eax,8),%edx
80106734:	80 
80106735:	83 e2 f0             	and    $0xfffffff0,%edx
80106738:	83 ca 0e             	or     $0xe,%edx
8010673b:	88 14 c5 e5 48 11 80 	mov    %dl,-0x7feeb71b(,%eax,8)
80106742:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106745:	0f b6 14 c5 e5 48 11 	movzbl -0x7feeb71b(,%eax,8),%edx
8010674c:	80 
8010674d:	83 e2 ef             	and    $0xffffffef,%edx
80106750:	88 14 c5 e5 48 11 80 	mov    %dl,-0x7feeb71b(,%eax,8)
80106757:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010675a:	0f b6 14 c5 e5 48 11 	movzbl -0x7feeb71b(,%eax,8),%edx
80106761:	80 
80106762:	83 e2 9f             	and    $0xffffff9f,%edx
80106765:	88 14 c5 e5 48 11 80 	mov    %dl,-0x7feeb71b(,%eax,8)
8010676c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010676f:	0f b6 14 c5 e5 48 11 	movzbl -0x7feeb71b(,%eax,8),%edx
80106776:	80 
80106777:	83 ca 80             	or     $0xffffff80,%edx
8010677a:	88 14 c5 e5 48 11 80 	mov    %dl,-0x7feeb71b(,%eax,8)
80106781:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106784:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
8010678b:	c1 e8 10             	shr    $0x10,%eax
8010678e:	89 c2                	mov    %eax,%edx
80106790:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106793:	66 89 14 c5 e6 48 11 	mov    %dx,-0x7feeb71a(,%eax,8)
8010679a:	80 
  for(i = 0; i < 256; i++)
8010679b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010679f:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801067a6:	0f 8e 30 ff ff ff    	jle    801066dc <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801067ac:	a1 98 b1 10 80       	mov    0x8010b198,%eax
801067b1:	66 a3 e0 4a 11 80    	mov    %ax,0x80114ae0
801067b7:	66 c7 05 e2 4a 11 80 	movw   $0x8,0x80114ae2
801067be:	08 00 
801067c0:	0f b6 05 e4 4a 11 80 	movzbl 0x80114ae4,%eax
801067c7:	83 e0 e0             	and    $0xffffffe0,%eax
801067ca:	a2 e4 4a 11 80       	mov    %al,0x80114ae4
801067cf:	0f b6 05 e4 4a 11 80 	movzbl 0x80114ae4,%eax
801067d6:	83 e0 1f             	and    $0x1f,%eax
801067d9:	a2 e4 4a 11 80       	mov    %al,0x80114ae4
801067de:	0f b6 05 e5 4a 11 80 	movzbl 0x80114ae5,%eax
801067e5:	83 c8 0f             	or     $0xf,%eax
801067e8:	a2 e5 4a 11 80       	mov    %al,0x80114ae5
801067ed:	0f b6 05 e5 4a 11 80 	movzbl 0x80114ae5,%eax
801067f4:	83 e0 ef             	and    $0xffffffef,%eax
801067f7:	a2 e5 4a 11 80       	mov    %al,0x80114ae5
801067fc:	0f b6 05 e5 4a 11 80 	movzbl 0x80114ae5,%eax
80106803:	83 c8 60             	or     $0x60,%eax
80106806:	a2 e5 4a 11 80       	mov    %al,0x80114ae5
8010680b:	0f b6 05 e5 4a 11 80 	movzbl 0x80114ae5,%eax
80106812:	83 c8 80             	or     $0xffffff80,%eax
80106815:	a2 e5 4a 11 80       	mov    %al,0x80114ae5
8010681a:	a1 98 b1 10 80       	mov    0x8010b198,%eax
8010681f:	c1 e8 10             	shr    $0x10,%eax
80106822:	66 a3 e6 4a 11 80    	mov    %ax,0x80114ae6
  
  initlock(&tickslock, "time");
80106828:	83 ec 08             	sub    $0x8,%esp
8010682b:	68 68 8a 10 80       	push   $0x80108a68
80106830:	68 a0 48 11 80       	push   $0x801148a0
80106835:	e8 e8 e7 ff ff       	call   80105022 <initlock>
8010683a:	83 c4 10             	add    $0x10,%esp
}
8010683d:	90                   	nop
8010683e:	c9                   	leave  
8010683f:	c3                   	ret    

80106840 <idtinit>:

void
idtinit(void)
{
80106840:	55                   	push   %ebp
80106841:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106843:	68 00 08 00 00       	push   $0x800
80106848:	68 e0 48 11 80       	push   $0x801148e0
8010684d:	e8 3d fe ff ff       	call   8010668f <lidt>
80106852:	83 c4 08             	add    $0x8,%esp
}
80106855:	90                   	nop
80106856:	c9                   	leave  
80106857:	c3                   	ret    

80106858 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106858:	55                   	push   %ebp
80106859:	89 e5                	mov    %esp,%ebp
8010685b:	57                   	push   %edi
8010685c:	56                   	push   %esi
8010685d:	53                   	push   %ebx
8010685e:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80106861:	8b 45 08             	mov    0x8(%ebp),%eax
80106864:	8b 40 30             	mov    0x30(%eax),%eax
80106867:	83 f8 40             	cmp    $0x40,%eax
8010686a:	75 3e                	jne    801068aa <trap+0x52>
    if(proc->killed)
8010686c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106872:	8b 40 24             	mov    0x24(%eax),%eax
80106875:	85 c0                	test   %eax,%eax
80106877:	74 05                	je     8010687e <trap+0x26>
      exit();
80106879:	e8 6b e0 ff ff       	call   801048e9 <exit>
    proc->tf = tf;
8010687e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106884:	8b 55 08             	mov    0x8(%ebp),%edx
80106887:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
8010688a:	e8 f3 ed ff ff       	call   80105682 <syscall>
    if(proc->killed)
8010688f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106895:	8b 40 24             	mov    0x24(%eax),%eax
80106898:	85 c0                	test   %eax,%eax
8010689a:	0f 84 1b 02 00 00    	je     80106abb <trap+0x263>
      exit();
801068a0:	e8 44 e0 ff ff       	call   801048e9 <exit>
    return;
801068a5:	e9 11 02 00 00       	jmp    80106abb <trap+0x263>
  }

  switch(tf->trapno){
801068aa:	8b 45 08             	mov    0x8(%ebp),%eax
801068ad:	8b 40 30             	mov    0x30(%eax),%eax
801068b0:	83 e8 20             	sub    $0x20,%eax
801068b3:	83 f8 1f             	cmp    $0x1f,%eax
801068b6:	0f 87 c0 00 00 00    	ja     8010697c <trap+0x124>
801068bc:	8b 04 85 10 8b 10 80 	mov    -0x7fef74f0(,%eax,4),%eax
801068c3:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
801068c5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801068cb:	0f b6 00             	movzbl (%eax),%eax
801068ce:	84 c0                	test   %al,%al
801068d0:	75 3d                	jne    8010690f <trap+0xb7>
      acquire(&tickslock);
801068d2:	83 ec 0c             	sub    $0xc,%esp
801068d5:	68 a0 48 11 80       	push   $0x801148a0
801068da:	e8 65 e7 ff ff       	call   80105044 <acquire>
801068df:	83 c4 10             	add    $0x10,%esp
      ticks++;
801068e2:	a1 e0 50 11 80       	mov    0x801150e0,%eax
801068e7:	83 c0 01             	add    $0x1,%eax
801068ea:	a3 e0 50 11 80       	mov    %eax,0x801150e0
      wakeup(&ticks);
801068ef:	83 ec 0c             	sub    $0xc,%esp
801068f2:	68 e0 50 11 80       	push   $0x801150e0
801068f7:	e8 3a e5 ff ff       	call   80104e36 <wakeup>
801068fc:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
801068ff:	83 ec 0c             	sub    $0xc,%esp
80106902:	68 a0 48 11 80       	push   $0x801148a0
80106907:	e8 9f e7 ff ff       	call   801050ab <release>
8010690c:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
8010690f:	e8 18 c7 ff ff       	call   8010302c <lapiceoi>
    break;
80106914:	e9 1c 01 00 00       	jmp    80106a35 <trap+0x1dd>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106919:	e8 1e bf ff ff       	call   8010283c <ideintr>
    lapiceoi();
8010691e:	e8 09 c7 ff ff       	call   8010302c <lapiceoi>
    break;
80106923:	e9 0d 01 00 00       	jmp    80106a35 <trap+0x1dd>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106928:	e8 fe c4 ff ff       	call   80102e2b <kbdintr>
    lapiceoi();
8010692d:	e8 fa c6 ff ff       	call   8010302c <lapiceoi>
    break;
80106932:	e9 fe 00 00 00       	jmp    80106a35 <trap+0x1dd>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106937:	e8 62 03 00 00       	call   80106c9e <uartintr>
    lapiceoi();
8010693c:	e8 eb c6 ff ff       	call   8010302c <lapiceoi>
    break;
80106941:	e9 ef 00 00 00       	jmp    80106a35 <trap+0x1dd>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106946:	8b 45 08             	mov    0x8(%ebp),%eax
80106949:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
8010694c:	8b 45 08             	mov    0x8(%ebp),%eax
8010694f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106953:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106956:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010695c:	0f b6 00             	movzbl (%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010695f:	0f b6 c0             	movzbl %al,%eax
80106962:	51                   	push   %ecx
80106963:	52                   	push   %edx
80106964:	50                   	push   %eax
80106965:	68 70 8a 10 80       	push   $0x80108a70
8010696a:	e8 55 9a ff ff       	call   801003c4 <cprintf>
8010696f:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106972:	e8 b5 c6 ff ff       	call   8010302c <lapiceoi>
    break;
80106977:	e9 b9 00 00 00       	jmp    80106a35 <trap+0x1dd>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
8010697c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106982:	85 c0                	test   %eax,%eax
80106984:	74 11                	je     80106997 <trap+0x13f>
80106986:	8b 45 08             	mov    0x8(%ebp),%eax
80106989:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010698d:	0f b7 c0             	movzwl %ax,%eax
80106990:	83 e0 03             	and    $0x3,%eax
80106993:	85 c0                	test   %eax,%eax
80106995:	75 40                	jne    801069d7 <trap+0x17f>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106997:	e8 1d fd ff ff       	call   801066b9 <rcr2>
8010699c:	89 c3                	mov    %eax,%ebx
8010699e:	8b 45 08             	mov    0x8(%ebp),%eax
801069a1:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
801069a4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801069aa:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801069ad:	0f b6 d0             	movzbl %al,%edx
801069b0:	8b 45 08             	mov    0x8(%ebp),%eax
801069b3:	8b 40 30             	mov    0x30(%eax),%eax
801069b6:	83 ec 0c             	sub    $0xc,%esp
801069b9:	53                   	push   %ebx
801069ba:	51                   	push   %ecx
801069bb:	52                   	push   %edx
801069bc:	50                   	push   %eax
801069bd:	68 94 8a 10 80       	push   $0x80108a94
801069c2:	e8 fd 99 ff ff       	call   801003c4 <cprintf>
801069c7:	83 c4 20             	add    $0x20,%esp
      panic("trap");
801069ca:	83 ec 0c             	sub    $0xc,%esp
801069cd:	68 c6 8a 10 80       	push   $0x80108ac6
801069d2:	e8 90 9b ff ff       	call   80100567 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069d7:	e8 dd fc ff ff       	call   801066b9 <rcr2>
801069dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801069df:	8b 45 08             	mov    0x8(%ebp),%eax
801069e2:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801069e5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801069eb:	0f b6 00             	movzbl (%eax),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069ee:	0f b6 d8             	movzbl %al,%ebx
801069f1:	8b 45 08             	mov    0x8(%ebp),%eax
801069f4:	8b 48 34             	mov    0x34(%eax),%ecx
801069f7:	8b 45 08             	mov    0x8(%ebp),%eax
801069fa:	8b 50 30             	mov    0x30(%eax),%edx
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801069fd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a03:	8d 78 6c             	lea    0x6c(%eax),%edi
80106a06:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106a0c:	8b 40 10             	mov    0x10(%eax),%eax
80106a0f:	ff 75 e4             	pushl  -0x1c(%ebp)
80106a12:	56                   	push   %esi
80106a13:	53                   	push   %ebx
80106a14:	51                   	push   %ecx
80106a15:	52                   	push   %edx
80106a16:	57                   	push   %edi
80106a17:	50                   	push   %eax
80106a18:	68 cc 8a 10 80       	push   $0x80108acc
80106a1d:	e8 a2 99 ff ff       	call   801003c4 <cprintf>
80106a22:	83 c4 20             	add    $0x20,%esp
            rcr2());
    proc->killed = 1;
80106a25:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a2b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106a32:	eb 01                	jmp    80106a35 <trap+0x1dd>
    break;
80106a34:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106a35:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a3b:	85 c0                	test   %eax,%eax
80106a3d:	74 24                	je     80106a63 <trap+0x20b>
80106a3f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a45:	8b 40 24             	mov    0x24(%eax),%eax
80106a48:	85 c0                	test   %eax,%eax
80106a4a:	74 17                	je     80106a63 <trap+0x20b>
80106a4c:	8b 45 08             	mov    0x8(%ebp),%eax
80106a4f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106a53:	0f b7 c0             	movzwl %ax,%eax
80106a56:	83 e0 03             	and    $0x3,%eax
80106a59:	83 f8 03             	cmp    $0x3,%eax
80106a5c:	75 05                	jne    80106a63 <trap+0x20b>
    exit();
80106a5e:	e8 86 de ff ff       	call   801048e9 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106a63:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a69:	85 c0                	test   %eax,%eax
80106a6b:	74 1e                	je     80106a8b <trap+0x233>
80106a6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a73:	8b 40 0c             	mov    0xc(%eax),%eax
80106a76:	83 f8 04             	cmp    $0x4,%eax
80106a79:	75 10                	jne    80106a8b <trap+0x233>
80106a7b:	8b 45 08             	mov    0x8(%ebp),%eax
80106a7e:	8b 40 30             	mov    0x30(%eax),%eax
80106a81:	83 f8 20             	cmp    $0x20,%eax
80106a84:	75 05                	jne    80106a8b <trap+0x233>
    yield();
80106a86:	e8 3f e2 ff ff       	call   80104cca <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106a8b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a91:	85 c0                	test   %eax,%eax
80106a93:	74 27                	je     80106abc <trap+0x264>
80106a95:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a9b:	8b 40 24             	mov    0x24(%eax),%eax
80106a9e:	85 c0                	test   %eax,%eax
80106aa0:	74 1a                	je     80106abc <trap+0x264>
80106aa2:	8b 45 08             	mov    0x8(%ebp),%eax
80106aa5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106aa9:	0f b7 c0             	movzwl %ax,%eax
80106aac:	83 e0 03             	and    $0x3,%eax
80106aaf:	83 f8 03             	cmp    $0x3,%eax
80106ab2:	75 08                	jne    80106abc <trap+0x264>
    exit();
80106ab4:	e8 30 de ff ff       	call   801048e9 <exit>
80106ab9:	eb 01                	jmp    80106abc <trap+0x264>
    return;
80106abb:	90                   	nop
}
80106abc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106abf:	5b                   	pop    %ebx
80106ac0:	5e                   	pop    %esi
80106ac1:	5f                   	pop    %edi
80106ac2:	5d                   	pop    %ebp
80106ac3:	c3                   	ret    

80106ac4 <inb>:
{
80106ac4:	55                   	push   %ebp
80106ac5:	89 e5                	mov    %esp,%ebp
80106ac7:	83 ec 14             	sub    $0x14,%esp
80106aca:	8b 45 08             	mov    0x8(%ebp),%eax
80106acd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106ad1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106ad5:	89 c2                	mov    %eax,%edx
80106ad7:	ec                   	in     (%dx),%al
80106ad8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106adb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106adf:	c9                   	leave  
80106ae0:	c3                   	ret    

80106ae1 <outb>:
{
80106ae1:	55                   	push   %ebp
80106ae2:	89 e5                	mov    %esp,%ebp
80106ae4:	83 ec 08             	sub    $0x8,%esp
80106ae7:	8b 45 08             	mov    0x8(%ebp),%eax
80106aea:	8b 55 0c             	mov    0xc(%ebp),%edx
80106aed:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106af1:	89 d0                	mov    %edx,%eax
80106af3:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106af6:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106afa:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106afe:	ee                   	out    %al,(%dx)
}
80106aff:	90                   	nop
80106b00:	c9                   	leave  
80106b01:	c3                   	ret    

80106b02 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106b02:	55                   	push   %ebp
80106b03:	89 e5                	mov    %esp,%ebp
80106b05:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106b08:	6a 00                	push   $0x0
80106b0a:	68 fa 03 00 00       	push   $0x3fa
80106b0f:	e8 cd ff ff ff       	call   80106ae1 <outb>
80106b14:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106b17:	68 80 00 00 00       	push   $0x80
80106b1c:	68 fb 03 00 00       	push   $0x3fb
80106b21:	e8 bb ff ff ff       	call   80106ae1 <outb>
80106b26:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106b29:	6a 0c                	push   $0xc
80106b2b:	68 f8 03 00 00       	push   $0x3f8
80106b30:	e8 ac ff ff ff       	call   80106ae1 <outb>
80106b35:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106b38:	6a 00                	push   $0x0
80106b3a:	68 f9 03 00 00       	push   $0x3f9
80106b3f:	e8 9d ff ff ff       	call   80106ae1 <outb>
80106b44:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106b47:	6a 03                	push   $0x3
80106b49:	68 fb 03 00 00       	push   $0x3fb
80106b4e:	e8 8e ff ff ff       	call   80106ae1 <outb>
80106b53:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106b56:	6a 00                	push   $0x0
80106b58:	68 fc 03 00 00       	push   $0x3fc
80106b5d:	e8 7f ff ff ff       	call   80106ae1 <outb>
80106b62:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106b65:	6a 01                	push   $0x1
80106b67:	68 f9 03 00 00       	push   $0x3f9
80106b6c:	e8 70 ff ff ff       	call   80106ae1 <outb>
80106b71:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106b74:	68 fd 03 00 00       	push   $0x3fd
80106b79:	e8 46 ff ff ff       	call   80106ac4 <inb>
80106b7e:	83 c4 04             	add    $0x4,%esp
80106b81:	3c ff                	cmp    $0xff,%al
80106b83:	74 6e                	je     80106bf3 <uartinit+0xf1>
    return;
  uart = 1;
80106b85:	c7 05 4c b6 10 80 01 	movl   $0x1,0x8010b64c
80106b8c:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106b8f:	68 fa 03 00 00       	push   $0x3fa
80106b94:	e8 2b ff ff ff       	call   80106ac4 <inb>
80106b99:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106b9c:	68 f8 03 00 00       	push   $0x3f8
80106ba1:	e8 1e ff ff ff       	call   80106ac4 <inb>
80106ba6:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80106ba9:	83 ec 0c             	sub    $0xc,%esp
80106bac:	6a 04                	push   $0x4
80106bae:	e8 8d d3 ff ff       	call   80103f40 <picenable>
80106bb3:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80106bb6:	83 ec 08             	sub    $0x8,%esp
80106bb9:	6a 00                	push   $0x0
80106bbb:	6a 04                	push   $0x4
80106bbd:	e8 1c bf ff ff       	call   80102ade <ioapicenable>
80106bc2:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106bc5:	c7 45 f4 90 8b 10 80 	movl   $0x80108b90,-0xc(%ebp)
80106bcc:	eb 19                	jmp    80106be7 <uartinit+0xe5>
    uartputc(*p);
80106bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bd1:	0f b6 00             	movzbl (%eax),%eax
80106bd4:	0f be c0             	movsbl %al,%eax
80106bd7:	83 ec 0c             	sub    $0xc,%esp
80106bda:	50                   	push   %eax
80106bdb:	e8 16 00 00 00       	call   80106bf6 <uartputc>
80106be0:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106be3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bea:	0f b6 00             	movzbl (%eax),%eax
80106bed:	84 c0                	test   %al,%al
80106bef:	75 dd                	jne    80106bce <uartinit+0xcc>
80106bf1:	eb 01                	jmp    80106bf4 <uartinit+0xf2>
    return;
80106bf3:	90                   	nop
}
80106bf4:	c9                   	leave  
80106bf5:	c3                   	ret    

80106bf6 <uartputc>:

void
uartputc(int c)
{
80106bf6:	55                   	push   %ebp
80106bf7:	89 e5                	mov    %esp,%ebp
80106bf9:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80106bfc:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106c01:	85 c0                	test   %eax,%eax
80106c03:	74 53                	je     80106c58 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106c05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106c0c:	eb 11                	jmp    80106c1f <uartputc+0x29>
    microdelay(10);
80106c0e:	83 ec 0c             	sub    $0xc,%esp
80106c11:	6a 0a                	push   $0xa
80106c13:	e8 2f c4 ff ff       	call   80103047 <microdelay>
80106c18:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106c1b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106c1f:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106c23:	7f 1a                	jg     80106c3f <uartputc+0x49>
80106c25:	83 ec 0c             	sub    $0xc,%esp
80106c28:	68 fd 03 00 00       	push   $0x3fd
80106c2d:	e8 92 fe ff ff       	call   80106ac4 <inb>
80106c32:	83 c4 10             	add    $0x10,%esp
80106c35:	0f b6 c0             	movzbl %al,%eax
80106c38:	83 e0 20             	and    $0x20,%eax
80106c3b:	85 c0                	test   %eax,%eax
80106c3d:	74 cf                	je     80106c0e <uartputc+0x18>
  outb(COM1+0, c);
80106c3f:	8b 45 08             	mov    0x8(%ebp),%eax
80106c42:	0f b6 c0             	movzbl %al,%eax
80106c45:	83 ec 08             	sub    $0x8,%esp
80106c48:	50                   	push   %eax
80106c49:	68 f8 03 00 00       	push   $0x3f8
80106c4e:	e8 8e fe ff ff       	call   80106ae1 <outb>
80106c53:	83 c4 10             	add    $0x10,%esp
80106c56:	eb 01                	jmp    80106c59 <uartputc+0x63>
    return;
80106c58:	90                   	nop
}
80106c59:	c9                   	leave  
80106c5a:	c3                   	ret    

80106c5b <uartgetc>:

static int
uartgetc(void)
{
80106c5b:	55                   	push   %ebp
80106c5c:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106c5e:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106c63:	85 c0                	test   %eax,%eax
80106c65:	75 07                	jne    80106c6e <uartgetc+0x13>
    return -1;
80106c67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c6c:	eb 2e                	jmp    80106c9c <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80106c6e:	68 fd 03 00 00       	push   $0x3fd
80106c73:	e8 4c fe ff ff       	call   80106ac4 <inb>
80106c78:	83 c4 04             	add    $0x4,%esp
80106c7b:	0f b6 c0             	movzbl %al,%eax
80106c7e:	83 e0 01             	and    $0x1,%eax
80106c81:	85 c0                	test   %eax,%eax
80106c83:	75 07                	jne    80106c8c <uartgetc+0x31>
    return -1;
80106c85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c8a:	eb 10                	jmp    80106c9c <uartgetc+0x41>
  return inb(COM1+0);
80106c8c:	68 f8 03 00 00       	push   $0x3f8
80106c91:	e8 2e fe ff ff       	call   80106ac4 <inb>
80106c96:	83 c4 04             	add    $0x4,%esp
80106c99:	0f b6 c0             	movzbl %al,%eax
}
80106c9c:	c9                   	leave  
80106c9d:	c3                   	ret    

80106c9e <uartintr>:

void
uartintr(void)
{
80106c9e:	55                   	push   %ebp
80106c9f:	89 e5                	mov    %esp,%ebp
80106ca1:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106ca4:	83 ec 0c             	sub    $0xc,%esp
80106ca7:	68 5b 6c 10 80       	push   $0x80106c5b
80106cac:	e8 51 9b ff ff       	call   80100802 <consoleintr>
80106cb1:	83 c4 10             	add    $0x10,%esp
}
80106cb4:	90                   	nop
80106cb5:	c9                   	leave  
80106cb6:	c3                   	ret    

80106cb7 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $0
80106cb9:	6a 00                	push   $0x0
  jmp alltraps
80106cbb:	e9 a4 f9 ff ff       	jmp    80106664 <alltraps>

80106cc0 <vector1>:
.globl vector1
vector1:
  pushl $0
80106cc0:	6a 00                	push   $0x0
  pushl $1
80106cc2:	6a 01                	push   $0x1
  jmp alltraps
80106cc4:	e9 9b f9 ff ff       	jmp    80106664 <alltraps>

80106cc9 <vector2>:
.globl vector2
vector2:
  pushl $0
80106cc9:	6a 00                	push   $0x0
  pushl $2
80106ccb:	6a 02                	push   $0x2
  jmp alltraps
80106ccd:	e9 92 f9 ff ff       	jmp    80106664 <alltraps>

80106cd2 <vector3>:
.globl vector3
vector3:
  pushl $0
80106cd2:	6a 00                	push   $0x0
  pushl $3
80106cd4:	6a 03                	push   $0x3
  jmp alltraps
80106cd6:	e9 89 f9 ff ff       	jmp    80106664 <alltraps>

80106cdb <vector4>:
.globl vector4
vector4:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $4
80106cdd:	6a 04                	push   $0x4
  jmp alltraps
80106cdf:	e9 80 f9 ff ff       	jmp    80106664 <alltraps>

80106ce4 <vector5>:
.globl vector5
vector5:
  pushl $0
80106ce4:	6a 00                	push   $0x0
  pushl $5
80106ce6:	6a 05                	push   $0x5
  jmp alltraps
80106ce8:	e9 77 f9 ff ff       	jmp    80106664 <alltraps>

80106ced <vector6>:
.globl vector6
vector6:
  pushl $0
80106ced:	6a 00                	push   $0x0
  pushl $6
80106cef:	6a 06                	push   $0x6
  jmp alltraps
80106cf1:	e9 6e f9 ff ff       	jmp    80106664 <alltraps>

80106cf6 <vector7>:
.globl vector7
vector7:
  pushl $0
80106cf6:	6a 00                	push   $0x0
  pushl $7
80106cf8:	6a 07                	push   $0x7
  jmp alltraps
80106cfa:	e9 65 f9 ff ff       	jmp    80106664 <alltraps>

80106cff <vector8>:
.globl vector8
vector8:
  pushl $8
80106cff:	6a 08                	push   $0x8
  jmp alltraps
80106d01:	e9 5e f9 ff ff       	jmp    80106664 <alltraps>

80106d06 <vector9>:
.globl vector9
vector9:
  pushl $0
80106d06:	6a 00                	push   $0x0
  pushl $9
80106d08:	6a 09                	push   $0x9
  jmp alltraps
80106d0a:	e9 55 f9 ff ff       	jmp    80106664 <alltraps>

80106d0f <vector10>:
.globl vector10
vector10:
  pushl $10
80106d0f:	6a 0a                	push   $0xa
  jmp alltraps
80106d11:	e9 4e f9 ff ff       	jmp    80106664 <alltraps>

80106d16 <vector11>:
.globl vector11
vector11:
  pushl $11
80106d16:	6a 0b                	push   $0xb
  jmp alltraps
80106d18:	e9 47 f9 ff ff       	jmp    80106664 <alltraps>

80106d1d <vector12>:
.globl vector12
vector12:
  pushl $12
80106d1d:	6a 0c                	push   $0xc
  jmp alltraps
80106d1f:	e9 40 f9 ff ff       	jmp    80106664 <alltraps>

80106d24 <vector13>:
.globl vector13
vector13:
  pushl $13
80106d24:	6a 0d                	push   $0xd
  jmp alltraps
80106d26:	e9 39 f9 ff ff       	jmp    80106664 <alltraps>

80106d2b <vector14>:
.globl vector14
vector14:
  pushl $14
80106d2b:	6a 0e                	push   $0xe
  jmp alltraps
80106d2d:	e9 32 f9 ff ff       	jmp    80106664 <alltraps>

80106d32 <vector15>:
.globl vector15
vector15:
  pushl $0
80106d32:	6a 00                	push   $0x0
  pushl $15
80106d34:	6a 0f                	push   $0xf
  jmp alltraps
80106d36:	e9 29 f9 ff ff       	jmp    80106664 <alltraps>

80106d3b <vector16>:
.globl vector16
vector16:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $16
80106d3d:	6a 10                	push   $0x10
  jmp alltraps
80106d3f:	e9 20 f9 ff ff       	jmp    80106664 <alltraps>

80106d44 <vector17>:
.globl vector17
vector17:
  pushl $17
80106d44:	6a 11                	push   $0x11
  jmp alltraps
80106d46:	e9 19 f9 ff ff       	jmp    80106664 <alltraps>

80106d4b <vector18>:
.globl vector18
vector18:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $18
80106d4d:	6a 12                	push   $0x12
  jmp alltraps
80106d4f:	e9 10 f9 ff ff       	jmp    80106664 <alltraps>

80106d54 <vector19>:
.globl vector19
vector19:
  pushl $0
80106d54:	6a 00                	push   $0x0
  pushl $19
80106d56:	6a 13                	push   $0x13
  jmp alltraps
80106d58:	e9 07 f9 ff ff       	jmp    80106664 <alltraps>

80106d5d <vector20>:
.globl vector20
vector20:
  pushl $0
80106d5d:	6a 00                	push   $0x0
  pushl $20
80106d5f:	6a 14                	push   $0x14
  jmp alltraps
80106d61:	e9 fe f8 ff ff       	jmp    80106664 <alltraps>

80106d66 <vector21>:
.globl vector21
vector21:
  pushl $0
80106d66:	6a 00                	push   $0x0
  pushl $21
80106d68:	6a 15                	push   $0x15
  jmp alltraps
80106d6a:	e9 f5 f8 ff ff       	jmp    80106664 <alltraps>

80106d6f <vector22>:
.globl vector22
vector22:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $22
80106d71:	6a 16                	push   $0x16
  jmp alltraps
80106d73:	e9 ec f8 ff ff       	jmp    80106664 <alltraps>

80106d78 <vector23>:
.globl vector23
vector23:
  pushl $0
80106d78:	6a 00                	push   $0x0
  pushl $23
80106d7a:	6a 17                	push   $0x17
  jmp alltraps
80106d7c:	e9 e3 f8 ff ff       	jmp    80106664 <alltraps>

80106d81 <vector24>:
.globl vector24
vector24:
  pushl $0
80106d81:	6a 00                	push   $0x0
  pushl $24
80106d83:	6a 18                	push   $0x18
  jmp alltraps
80106d85:	e9 da f8 ff ff       	jmp    80106664 <alltraps>

80106d8a <vector25>:
.globl vector25
vector25:
  pushl $0
80106d8a:	6a 00                	push   $0x0
  pushl $25
80106d8c:	6a 19                	push   $0x19
  jmp alltraps
80106d8e:	e9 d1 f8 ff ff       	jmp    80106664 <alltraps>

80106d93 <vector26>:
.globl vector26
vector26:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $26
80106d95:	6a 1a                	push   $0x1a
  jmp alltraps
80106d97:	e9 c8 f8 ff ff       	jmp    80106664 <alltraps>

80106d9c <vector27>:
.globl vector27
vector27:
  pushl $0
80106d9c:	6a 00                	push   $0x0
  pushl $27
80106d9e:	6a 1b                	push   $0x1b
  jmp alltraps
80106da0:	e9 bf f8 ff ff       	jmp    80106664 <alltraps>

80106da5 <vector28>:
.globl vector28
vector28:
  pushl $0
80106da5:	6a 00                	push   $0x0
  pushl $28
80106da7:	6a 1c                	push   $0x1c
  jmp alltraps
80106da9:	e9 b6 f8 ff ff       	jmp    80106664 <alltraps>

80106dae <vector29>:
.globl vector29
vector29:
  pushl $0
80106dae:	6a 00                	push   $0x0
  pushl $29
80106db0:	6a 1d                	push   $0x1d
  jmp alltraps
80106db2:	e9 ad f8 ff ff       	jmp    80106664 <alltraps>

80106db7 <vector30>:
.globl vector30
vector30:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $30
80106db9:	6a 1e                	push   $0x1e
  jmp alltraps
80106dbb:	e9 a4 f8 ff ff       	jmp    80106664 <alltraps>

80106dc0 <vector31>:
.globl vector31
vector31:
  pushl $0
80106dc0:	6a 00                	push   $0x0
  pushl $31
80106dc2:	6a 1f                	push   $0x1f
  jmp alltraps
80106dc4:	e9 9b f8 ff ff       	jmp    80106664 <alltraps>

80106dc9 <vector32>:
.globl vector32
vector32:
  pushl $0
80106dc9:	6a 00                	push   $0x0
  pushl $32
80106dcb:	6a 20                	push   $0x20
  jmp alltraps
80106dcd:	e9 92 f8 ff ff       	jmp    80106664 <alltraps>

80106dd2 <vector33>:
.globl vector33
vector33:
  pushl $0
80106dd2:	6a 00                	push   $0x0
  pushl $33
80106dd4:	6a 21                	push   $0x21
  jmp alltraps
80106dd6:	e9 89 f8 ff ff       	jmp    80106664 <alltraps>

80106ddb <vector34>:
.globl vector34
vector34:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $34
80106ddd:	6a 22                	push   $0x22
  jmp alltraps
80106ddf:	e9 80 f8 ff ff       	jmp    80106664 <alltraps>

80106de4 <vector35>:
.globl vector35
vector35:
  pushl $0
80106de4:	6a 00                	push   $0x0
  pushl $35
80106de6:	6a 23                	push   $0x23
  jmp alltraps
80106de8:	e9 77 f8 ff ff       	jmp    80106664 <alltraps>

80106ded <vector36>:
.globl vector36
vector36:
  pushl $0
80106ded:	6a 00                	push   $0x0
  pushl $36
80106def:	6a 24                	push   $0x24
  jmp alltraps
80106df1:	e9 6e f8 ff ff       	jmp    80106664 <alltraps>

80106df6 <vector37>:
.globl vector37
vector37:
  pushl $0
80106df6:	6a 00                	push   $0x0
  pushl $37
80106df8:	6a 25                	push   $0x25
  jmp alltraps
80106dfa:	e9 65 f8 ff ff       	jmp    80106664 <alltraps>

80106dff <vector38>:
.globl vector38
vector38:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $38
80106e01:	6a 26                	push   $0x26
  jmp alltraps
80106e03:	e9 5c f8 ff ff       	jmp    80106664 <alltraps>

80106e08 <vector39>:
.globl vector39
vector39:
  pushl $0
80106e08:	6a 00                	push   $0x0
  pushl $39
80106e0a:	6a 27                	push   $0x27
  jmp alltraps
80106e0c:	e9 53 f8 ff ff       	jmp    80106664 <alltraps>

80106e11 <vector40>:
.globl vector40
vector40:
  pushl $0
80106e11:	6a 00                	push   $0x0
  pushl $40
80106e13:	6a 28                	push   $0x28
  jmp alltraps
80106e15:	e9 4a f8 ff ff       	jmp    80106664 <alltraps>

80106e1a <vector41>:
.globl vector41
vector41:
  pushl $0
80106e1a:	6a 00                	push   $0x0
  pushl $41
80106e1c:	6a 29                	push   $0x29
  jmp alltraps
80106e1e:	e9 41 f8 ff ff       	jmp    80106664 <alltraps>

80106e23 <vector42>:
.globl vector42
vector42:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $42
80106e25:	6a 2a                	push   $0x2a
  jmp alltraps
80106e27:	e9 38 f8 ff ff       	jmp    80106664 <alltraps>

80106e2c <vector43>:
.globl vector43
vector43:
  pushl $0
80106e2c:	6a 00                	push   $0x0
  pushl $43
80106e2e:	6a 2b                	push   $0x2b
  jmp alltraps
80106e30:	e9 2f f8 ff ff       	jmp    80106664 <alltraps>

80106e35 <vector44>:
.globl vector44
vector44:
  pushl $0
80106e35:	6a 00                	push   $0x0
  pushl $44
80106e37:	6a 2c                	push   $0x2c
  jmp alltraps
80106e39:	e9 26 f8 ff ff       	jmp    80106664 <alltraps>

80106e3e <vector45>:
.globl vector45
vector45:
  pushl $0
80106e3e:	6a 00                	push   $0x0
  pushl $45
80106e40:	6a 2d                	push   $0x2d
  jmp alltraps
80106e42:	e9 1d f8 ff ff       	jmp    80106664 <alltraps>

80106e47 <vector46>:
.globl vector46
vector46:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $46
80106e49:	6a 2e                	push   $0x2e
  jmp alltraps
80106e4b:	e9 14 f8 ff ff       	jmp    80106664 <alltraps>

80106e50 <vector47>:
.globl vector47
vector47:
  pushl $0
80106e50:	6a 00                	push   $0x0
  pushl $47
80106e52:	6a 2f                	push   $0x2f
  jmp alltraps
80106e54:	e9 0b f8 ff ff       	jmp    80106664 <alltraps>

80106e59 <vector48>:
.globl vector48
vector48:
  pushl $0
80106e59:	6a 00                	push   $0x0
  pushl $48
80106e5b:	6a 30                	push   $0x30
  jmp alltraps
80106e5d:	e9 02 f8 ff ff       	jmp    80106664 <alltraps>

80106e62 <vector49>:
.globl vector49
vector49:
  pushl $0
80106e62:	6a 00                	push   $0x0
  pushl $49
80106e64:	6a 31                	push   $0x31
  jmp alltraps
80106e66:	e9 f9 f7 ff ff       	jmp    80106664 <alltraps>

80106e6b <vector50>:
.globl vector50
vector50:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $50
80106e6d:	6a 32                	push   $0x32
  jmp alltraps
80106e6f:	e9 f0 f7 ff ff       	jmp    80106664 <alltraps>

80106e74 <vector51>:
.globl vector51
vector51:
  pushl $0
80106e74:	6a 00                	push   $0x0
  pushl $51
80106e76:	6a 33                	push   $0x33
  jmp alltraps
80106e78:	e9 e7 f7 ff ff       	jmp    80106664 <alltraps>

80106e7d <vector52>:
.globl vector52
vector52:
  pushl $0
80106e7d:	6a 00                	push   $0x0
  pushl $52
80106e7f:	6a 34                	push   $0x34
  jmp alltraps
80106e81:	e9 de f7 ff ff       	jmp    80106664 <alltraps>

80106e86 <vector53>:
.globl vector53
vector53:
  pushl $0
80106e86:	6a 00                	push   $0x0
  pushl $53
80106e88:	6a 35                	push   $0x35
  jmp alltraps
80106e8a:	e9 d5 f7 ff ff       	jmp    80106664 <alltraps>

80106e8f <vector54>:
.globl vector54
vector54:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $54
80106e91:	6a 36                	push   $0x36
  jmp alltraps
80106e93:	e9 cc f7 ff ff       	jmp    80106664 <alltraps>

80106e98 <vector55>:
.globl vector55
vector55:
  pushl $0
80106e98:	6a 00                	push   $0x0
  pushl $55
80106e9a:	6a 37                	push   $0x37
  jmp alltraps
80106e9c:	e9 c3 f7 ff ff       	jmp    80106664 <alltraps>

80106ea1 <vector56>:
.globl vector56
vector56:
  pushl $0
80106ea1:	6a 00                	push   $0x0
  pushl $56
80106ea3:	6a 38                	push   $0x38
  jmp alltraps
80106ea5:	e9 ba f7 ff ff       	jmp    80106664 <alltraps>

80106eaa <vector57>:
.globl vector57
vector57:
  pushl $0
80106eaa:	6a 00                	push   $0x0
  pushl $57
80106eac:	6a 39                	push   $0x39
  jmp alltraps
80106eae:	e9 b1 f7 ff ff       	jmp    80106664 <alltraps>

80106eb3 <vector58>:
.globl vector58
vector58:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $58
80106eb5:	6a 3a                	push   $0x3a
  jmp alltraps
80106eb7:	e9 a8 f7 ff ff       	jmp    80106664 <alltraps>

80106ebc <vector59>:
.globl vector59
vector59:
  pushl $0
80106ebc:	6a 00                	push   $0x0
  pushl $59
80106ebe:	6a 3b                	push   $0x3b
  jmp alltraps
80106ec0:	e9 9f f7 ff ff       	jmp    80106664 <alltraps>

80106ec5 <vector60>:
.globl vector60
vector60:
  pushl $0
80106ec5:	6a 00                	push   $0x0
  pushl $60
80106ec7:	6a 3c                	push   $0x3c
  jmp alltraps
80106ec9:	e9 96 f7 ff ff       	jmp    80106664 <alltraps>

80106ece <vector61>:
.globl vector61
vector61:
  pushl $0
80106ece:	6a 00                	push   $0x0
  pushl $61
80106ed0:	6a 3d                	push   $0x3d
  jmp alltraps
80106ed2:	e9 8d f7 ff ff       	jmp    80106664 <alltraps>

80106ed7 <vector62>:
.globl vector62
vector62:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $62
80106ed9:	6a 3e                	push   $0x3e
  jmp alltraps
80106edb:	e9 84 f7 ff ff       	jmp    80106664 <alltraps>

80106ee0 <vector63>:
.globl vector63
vector63:
  pushl $0
80106ee0:	6a 00                	push   $0x0
  pushl $63
80106ee2:	6a 3f                	push   $0x3f
  jmp alltraps
80106ee4:	e9 7b f7 ff ff       	jmp    80106664 <alltraps>

80106ee9 <vector64>:
.globl vector64
vector64:
  pushl $0
80106ee9:	6a 00                	push   $0x0
  pushl $64
80106eeb:	6a 40                	push   $0x40
  jmp alltraps
80106eed:	e9 72 f7 ff ff       	jmp    80106664 <alltraps>

80106ef2 <vector65>:
.globl vector65
vector65:
  pushl $0
80106ef2:	6a 00                	push   $0x0
  pushl $65
80106ef4:	6a 41                	push   $0x41
  jmp alltraps
80106ef6:	e9 69 f7 ff ff       	jmp    80106664 <alltraps>

80106efb <vector66>:
.globl vector66
vector66:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $66
80106efd:	6a 42                	push   $0x42
  jmp alltraps
80106eff:	e9 60 f7 ff ff       	jmp    80106664 <alltraps>

80106f04 <vector67>:
.globl vector67
vector67:
  pushl $0
80106f04:	6a 00                	push   $0x0
  pushl $67
80106f06:	6a 43                	push   $0x43
  jmp alltraps
80106f08:	e9 57 f7 ff ff       	jmp    80106664 <alltraps>

80106f0d <vector68>:
.globl vector68
vector68:
  pushl $0
80106f0d:	6a 00                	push   $0x0
  pushl $68
80106f0f:	6a 44                	push   $0x44
  jmp alltraps
80106f11:	e9 4e f7 ff ff       	jmp    80106664 <alltraps>

80106f16 <vector69>:
.globl vector69
vector69:
  pushl $0
80106f16:	6a 00                	push   $0x0
  pushl $69
80106f18:	6a 45                	push   $0x45
  jmp alltraps
80106f1a:	e9 45 f7 ff ff       	jmp    80106664 <alltraps>

80106f1f <vector70>:
.globl vector70
vector70:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $70
80106f21:	6a 46                	push   $0x46
  jmp alltraps
80106f23:	e9 3c f7 ff ff       	jmp    80106664 <alltraps>

80106f28 <vector71>:
.globl vector71
vector71:
  pushl $0
80106f28:	6a 00                	push   $0x0
  pushl $71
80106f2a:	6a 47                	push   $0x47
  jmp alltraps
80106f2c:	e9 33 f7 ff ff       	jmp    80106664 <alltraps>

80106f31 <vector72>:
.globl vector72
vector72:
  pushl $0
80106f31:	6a 00                	push   $0x0
  pushl $72
80106f33:	6a 48                	push   $0x48
  jmp alltraps
80106f35:	e9 2a f7 ff ff       	jmp    80106664 <alltraps>

80106f3a <vector73>:
.globl vector73
vector73:
  pushl $0
80106f3a:	6a 00                	push   $0x0
  pushl $73
80106f3c:	6a 49                	push   $0x49
  jmp alltraps
80106f3e:	e9 21 f7 ff ff       	jmp    80106664 <alltraps>

80106f43 <vector74>:
.globl vector74
vector74:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $74
80106f45:	6a 4a                	push   $0x4a
  jmp alltraps
80106f47:	e9 18 f7 ff ff       	jmp    80106664 <alltraps>

80106f4c <vector75>:
.globl vector75
vector75:
  pushl $0
80106f4c:	6a 00                	push   $0x0
  pushl $75
80106f4e:	6a 4b                	push   $0x4b
  jmp alltraps
80106f50:	e9 0f f7 ff ff       	jmp    80106664 <alltraps>

80106f55 <vector76>:
.globl vector76
vector76:
  pushl $0
80106f55:	6a 00                	push   $0x0
  pushl $76
80106f57:	6a 4c                	push   $0x4c
  jmp alltraps
80106f59:	e9 06 f7 ff ff       	jmp    80106664 <alltraps>

80106f5e <vector77>:
.globl vector77
vector77:
  pushl $0
80106f5e:	6a 00                	push   $0x0
  pushl $77
80106f60:	6a 4d                	push   $0x4d
  jmp alltraps
80106f62:	e9 fd f6 ff ff       	jmp    80106664 <alltraps>

80106f67 <vector78>:
.globl vector78
vector78:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $78
80106f69:	6a 4e                	push   $0x4e
  jmp alltraps
80106f6b:	e9 f4 f6 ff ff       	jmp    80106664 <alltraps>

80106f70 <vector79>:
.globl vector79
vector79:
  pushl $0
80106f70:	6a 00                	push   $0x0
  pushl $79
80106f72:	6a 4f                	push   $0x4f
  jmp alltraps
80106f74:	e9 eb f6 ff ff       	jmp    80106664 <alltraps>

80106f79 <vector80>:
.globl vector80
vector80:
  pushl $0
80106f79:	6a 00                	push   $0x0
  pushl $80
80106f7b:	6a 50                	push   $0x50
  jmp alltraps
80106f7d:	e9 e2 f6 ff ff       	jmp    80106664 <alltraps>

80106f82 <vector81>:
.globl vector81
vector81:
  pushl $0
80106f82:	6a 00                	push   $0x0
  pushl $81
80106f84:	6a 51                	push   $0x51
  jmp alltraps
80106f86:	e9 d9 f6 ff ff       	jmp    80106664 <alltraps>

80106f8b <vector82>:
.globl vector82
vector82:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $82
80106f8d:	6a 52                	push   $0x52
  jmp alltraps
80106f8f:	e9 d0 f6 ff ff       	jmp    80106664 <alltraps>

80106f94 <vector83>:
.globl vector83
vector83:
  pushl $0
80106f94:	6a 00                	push   $0x0
  pushl $83
80106f96:	6a 53                	push   $0x53
  jmp alltraps
80106f98:	e9 c7 f6 ff ff       	jmp    80106664 <alltraps>

80106f9d <vector84>:
.globl vector84
vector84:
  pushl $0
80106f9d:	6a 00                	push   $0x0
  pushl $84
80106f9f:	6a 54                	push   $0x54
  jmp alltraps
80106fa1:	e9 be f6 ff ff       	jmp    80106664 <alltraps>

80106fa6 <vector85>:
.globl vector85
vector85:
  pushl $0
80106fa6:	6a 00                	push   $0x0
  pushl $85
80106fa8:	6a 55                	push   $0x55
  jmp alltraps
80106faa:	e9 b5 f6 ff ff       	jmp    80106664 <alltraps>

80106faf <vector86>:
.globl vector86
vector86:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $86
80106fb1:	6a 56                	push   $0x56
  jmp alltraps
80106fb3:	e9 ac f6 ff ff       	jmp    80106664 <alltraps>

80106fb8 <vector87>:
.globl vector87
vector87:
  pushl $0
80106fb8:	6a 00                	push   $0x0
  pushl $87
80106fba:	6a 57                	push   $0x57
  jmp alltraps
80106fbc:	e9 a3 f6 ff ff       	jmp    80106664 <alltraps>

80106fc1 <vector88>:
.globl vector88
vector88:
  pushl $0
80106fc1:	6a 00                	push   $0x0
  pushl $88
80106fc3:	6a 58                	push   $0x58
  jmp alltraps
80106fc5:	e9 9a f6 ff ff       	jmp    80106664 <alltraps>

80106fca <vector89>:
.globl vector89
vector89:
  pushl $0
80106fca:	6a 00                	push   $0x0
  pushl $89
80106fcc:	6a 59                	push   $0x59
  jmp alltraps
80106fce:	e9 91 f6 ff ff       	jmp    80106664 <alltraps>

80106fd3 <vector90>:
.globl vector90
vector90:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $90
80106fd5:	6a 5a                	push   $0x5a
  jmp alltraps
80106fd7:	e9 88 f6 ff ff       	jmp    80106664 <alltraps>

80106fdc <vector91>:
.globl vector91
vector91:
  pushl $0
80106fdc:	6a 00                	push   $0x0
  pushl $91
80106fde:	6a 5b                	push   $0x5b
  jmp alltraps
80106fe0:	e9 7f f6 ff ff       	jmp    80106664 <alltraps>

80106fe5 <vector92>:
.globl vector92
vector92:
  pushl $0
80106fe5:	6a 00                	push   $0x0
  pushl $92
80106fe7:	6a 5c                	push   $0x5c
  jmp alltraps
80106fe9:	e9 76 f6 ff ff       	jmp    80106664 <alltraps>

80106fee <vector93>:
.globl vector93
vector93:
  pushl $0
80106fee:	6a 00                	push   $0x0
  pushl $93
80106ff0:	6a 5d                	push   $0x5d
  jmp alltraps
80106ff2:	e9 6d f6 ff ff       	jmp    80106664 <alltraps>

80106ff7 <vector94>:
.globl vector94
vector94:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $94
80106ff9:	6a 5e                	push   $0x5e
  jmp alltraps
80106ffb:	e9 64 f6 ff ff       	jmp    80106664 <alltraps>

80107000 <vector95>:
.globl vector95
vector95:
  pushl $0
80107000:	6a 00                	push   $0x0
  pushl $95
80107002:	6a 5f                	push   $0x5f
  jmp alltraps
80107004:	e9 5b f6 ff ff       	jmp    80106664 <alltraps>

80107009 <vector96>:
.globl vector96
vector96:
  pushl $0
80107009:	6a 00                	push   $0x0
  pushl $96
8010700b:	6a 60                	push   $0x60
  jmp alltraps
8010700d:	e9 52 f6 ff ff       	jmp    80106664 <alltraps>

80107012 <vector97>:
.globl vector97
vector97:
  pushl $0
80107012:	6a 00                	push   $0x0
  pushl $97
80107014:	6a 61                	push   $0x61
  jmp alltraps
80107016:	e9 49 f6 ff ff       	jmp    80106664 <alltraps>

8010701b <vector98>:
.globl vector98
vector98:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $98
8010701d:	6a 62                	push   $0x62
  jmp alltraps
8010701f:	e9 40 f6 ff ff       	jmp    80106664 <alltraps>

80107024 <vector99>:
.globl vector99
vector99:
  pushl $0
80107024:	6a 00                	push   $0x0
  pushl $99
80107026:	6a 63                	push   $0x63
  jmp alltraps
80107028:	e9 37 f6 ff ff       	jmp    80106664 <alltraps>

8010702d <vector100>:
.globl vector100
vector100:
  pushl $0
8010702d:	6a 00                	push   $0x0
  pushl $100
8010702f:	6a 64                	push   $0x64
  jmp alltraps
80107031:	e9 2e f6 ff ff       	jmp    80106664 <alltraps>

80107036 <vector101>:
.globl vector101
vector101:
  pushl $0
80107036:	6a 00                	push   $0x0
  pushl $101
80107038:	6a 65                	push   $0x65
  jmp alltraps
8010703a:	e9 25 f6 ff ff       	jmp    80106664 <alltraps>

8010703f <vector102>:
.globl vector102
vector102:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $102
80107041:	6a 66                	push   $0x66
  jmp alltraps
80107043:	e9 1c f6 ff ff       	jmp    80106664 <alltraps>

80107048 <vector103>:
.globl vector103
vector103:
  pushl $0
80107048:	6a 00                	push   $0x0
  pushl $103
8010704a:	6a 67                	push   $0x67
  jmp alltraps
8010704c:	e9 13 f6 ff ff       	jmp    80106664 <alltraps>

80107051 <vector104>:
.globl vector104
vector104:
  pushl $0
80107051:	6a 00                	push   $0x0
  pushl $104
80107053:	6a 68                	push   $0x68
  jmp alltraps
80107055:	e9 0a f6 ff ff       	jmp    80106664 <alltraps>

8010705a <vector105>:
.globl vector105
vector105:
  pushl $0
8010705a:	6a 00                	push   $0x0
  pushl $105
8010705c:	6a 69                	push   $0x69
  jmp alltraps
8010705e:	e9 01 f6 ff ff       	jmp    80106664 <alltraps>

80107063 <vector106>:
.globl vector106
vector106:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $106
80107065:	6a 6a                	push   $0x6a
  jmp alltraps
80107067:	e9 f8 f5 ff ff       	jmp    80106664 <alltraps>

8010706c <vector107>:
.globl vector107
vector107:
  pushl $0
8010706c:	6a 00                	push   $0x0
  pushl $107
8010706e:	6a 6b                	push   $0x6b
  jmp alltraps
80107070:	e9 ef f5 ff ff       	jmp    80106664 <alltraps>

80107075 <vector108>:
.globl vector108
vector108:
  pushl $0
80107075:	6a 00                	push   $0x0
  pushl $108
80107077:	6a 6c                	push   $0x6c
  jmp alltraps
80107079:	e9 e6 f5 ff ff       	jmp    80106664 <alltraps>

8010707e <vector109>:
.globl vector109
vector109:
  pushl $0
8010707e:	6a 00                	push   $0x0
  pushl $109
80107080:	6a 6d                	push   $0x6d
  jmp alltraps
80107082:	e9 dd f5 ff ff       	jmp    80106664 <alltraps>

80107087 <vector110>:
.globl vector110
vector110:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $110
80107089:	6a 6e                	push   $0x6e
  jmp alltraps
8010708b:	e9 d4 f5 ff ff       	jmp    80106664 <alltraps>

80107090 <vector111>:
.globl vector111
vector111:
  pushl $0
80107090:	6a 00                	push   $0x0
  pushl $111
80107092:	6a 6f                	push   $0x6f
  jmp alltraps
80107094:	e9 cb f5 ff ff       	jmp    80106664 <alltraps>

80107099 <vector112>:
.globl vector112
vector112:
  pushl $0
80107099:	6a 00                	push   $0x0
  pushl $112
8010709b:	6a 70                	push   $0x70
  jmp alltraps
8010709d:	e9 c2 f5 ff ff       	jmp    80106664 <alltraps>

801070a2 <vector113>:
.globl vector113
vector113:
  pushl $0
801070a2:	6a 00                	push   $0x0
  pushl $113
801070a4:	6a 71                	push   $0x71
  jmp alltraps
801070a6:	e9 b9 f5 ff ff       	jmp    80106664 <alltraps>

801070ab <vector114>:
.globl vector114
vector114:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $114
801070ad:	6a 72                	push   $0x72
  jmp alltraps
801070af:	e9 b0 f5 ff ff       	jmp    80106664 <alltraps>

801070b4 <vector115>:
.globl vector115
vector115:
  pushl $0
801070b4:	6a 00                	push   $0x0
  pushl $115
801070b6:	6a 73                	push   $0x73
  jmp alltraps
801070b8:	e9 a7 f5 ff ff       	jmp    80106664 <alltraps>

801070bd <vector116>:
.globl vector116
vector116:
  pushl $0
801070bd:	6a 00                	push   $0x0
  pushl $116
801070bf:	6a 74                	push   $0x74
  jmp alltraps
801070c1:	e9 9e f5 ff ff       	jmp    80106664 <alltraps>

801070c6 <vector117>:
.globl vector117
vector117:
  pushl $0
801070c6:	6a 00                	push   $0x0
  pushl $117
801070c8:	6a 75                	push   $0x75
  jmp alltraps
801070ca:	e9 95 f5 ff ff       	jmp    80106664 <alltraps>

801070cf <vector118>:
.globl vector118
vector118:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $118
801070d1:	6a 76                	push   $0x76
  jmp alltraps
801070d3:	e9 8c f5 ff ff       	jmp    80106664 <alltraps>

801070d8 <vector119>:
.globl vector119
vector119:
  pushl $0
801070d8:	6a 00                	push   $0x0
  pushl $119
801070da:	6a 77                	push   $0x77
  jmp alltraps
801070dc:	e9 83 f5 ff ff       	jmp    80106664 <alltraps>

801070e1 <vector120>:
.globl vector120
vector120:
  pushl $0
801070e1:	6a 00                	push   $0x0
  pushl $120
801070e3:	6a 78                	push   $0x78
  jmp alltraps
801070e5:	e9 7a f5 ff ff       	jmp    80106664 <alltraps>

801070ea <vector121>:
.globl vector121
vector121:
  pushl $0
801070ea:	6a 00                	push   $0x0
  pushl $121
801070ec:	6a 79                	push   $0x79
  jmp alltraps
801070ee:	e9 71 f5 ff ff       	jmp    80106664 <alltraps>

801070f3 <vector122>:
.globl vector122
vector122:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $122
801070f5:	6a 7a                	push   $0x7a
  jmp alltraps
801070f7:	e9 68 f5 ff ff       	jmp    80106664 <alltraps>

801070fc <vector123>:
.globl vector123
vector123:
  pushl $0
801070fc:	6a 00                	push   $0x0
  pushl $123
801070fe:	6a 7b                	push   $0x7b
  jmp alltraps
80107100:	e9 5f f5 ff ff       	jmp    80106664 <alltraps>

80107105 <vector124>:
.globl vector124
vector124:
  pushl $0
80107105:	6a 00                	push   $0x0
  pushl $124
80107107:	6a 7c                	push   $0x7c
  jmp alltraps
80107109:	e9 56 f5 ff ff       	jmp    80106664 <alltraps>

8010710e <vector125>:
.globl vector125
vector125:
  pushl $0
8010710e:	6a 00                	push   $0x0
  pushl $125
80107110:	6a 7d                	push   $0x7d
  jmp alltraps
80107112:	e9 4d f5 ff ff       	jmp    80106664 <alltraps>

80107117 <vector126>:
.globl vector126
vector126:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $126
80107119:	6a 7e                	push   $0x7e
  jmp alltraps
8010711b:	e9 44 f5 ff ff       	jmp    80106664 <alltraps>

80107120 <vector127>:
.globl vector127
vector127:
  pushl $0
80107120:	6a 00                	push   $0x0
  pushl $127
80107122:	6a 7f                	push   $0x7f
  jmp alltraps
80107124:	e9 3b f5 ff ff       	jmp    80106664 <alltraps>

80107129 <vector128>:
.globl vector128
vector128:
  pushl $0
80107129:	6a 00                	push   $0x0
  pushl $128
8010712b:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107130:	e9 2f f5 ff ff       	jmp    80106664 <alltraps>

80107135 <vector129>:
.globl vector129
vector129:
  pushl $0
80107135:	6a 00                	push   $0x0
  pushl $129
80107137:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010713c:	e9 23 f5 ff ff       	jmp    80106664 <alltraps>

80107141 <vector130>:
.globl vector130
vector130:
  pushl $0
80107141:	6a 00                	push   $0x0
  pushl $130
80107143:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107148:	e9 17 f5 ff ff       	jmp    80106664 <alltraps>

8010714d <vector131>:
.globl vector131
vector131:
  pushl $0
8010714d:	6a 00                	push   $0x0
  pushl $131
8010714f:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107154:	e9 0b f5 ff ff       	jmp    80106664 <alltraps>

80107159 <vector132>:
.globl vector132
vector132:
  pushl $0
80107159:	6a 00                	push   $0x0
  pushl $132
8010715b:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107160:	e9 ff f4 ff ff       	jmp    80106664 <alltraps>

80107165 <vector133>:
.globl vector133
vector133:
  pushl $0
80107165:	6a 00                	push   $0x0
  pushl $133
80107167:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010716c:	e9 f3 f4 ff ff       	jmp    80106664 <alltraps>

80107171 <vector134>:
.globl vector134
vector134:
  pushl $0
80107171:	6a 00                	push   $0x0
  pushl $134
80107173:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107178:	e9 e7 f4 ff ff       	jmp    80106664 <alltraps>

8010717d <vector135>:
.globl vector135
vector135:
  pushl $0
8010717d:	6a 00                	push   $0x0
  pushl $135
8010717f:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107184:	e9 db f4 ff ff       	jmp    80106664 <alltraps>

80107189 <vector136>:
.globl vector136
vector136:
  pushl $0
80107189:	6a 00                	push   $0x0
  pushl $136
8010718b:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107190:	e9 cf f4 ff ff       	jmp    80106664 <alltraps>

80107195 <vector137>:
.globl vector137
vector137:
  pushl $0
80107195:	6a 00                	push   $0x0
  pushl $137
80107197:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010719c:	e9 c3 f4 ff ff       	jmp    80106664 <alltraps>

801071a1 <vector138>:
.globl vector138
vector138:
  pushl $0
801071a1:	6a 00                	push   $0x0
  pushl $138
801071a3:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801071a8:	e9 b7 f4 ff ff       	jmp    80106664 <alltraps>

801071ad <vector139>:
.globl vector139
vector139:
  pushl $0
801071ad:	6a 00                	push   $0x0
  pushl $139
801071af:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801071b4:	e9 ab f4 ff ff       	jmp    80106664 <alltraps>

801071b9 <vector140>:
.globl vector140
vector140:
  pushl $0
801071b9:	6a 00                	push   $0x0
  pushl $140
801071bb:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801071c0:	e9 9f f4 ff ff       	jmp    80106664 <alltraps>

801071c5 <vector141>:
.globl vector141
vector141:
  pushl $0
801071c5:	6a 00                	push   $0x0
  pushl $141
801071c7:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801071cc:	e9 93 f4 ff ff       	jmp    80106664 <alltraps>

801071d1 <vector142>:
.globl vector142
vector142:
  pushl $0
801071d1:	6a 00                	push   $0x0
  pushl $142
801071d3:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801071d8:	e9 87 f4 ff ff       	jmp    80106664 <alltraps>

801071dd <vector143>:
.globl vector143
vector143:
  pushl $0
801071dd:	6a 00                	push   $0x0
  pushl $143
801071df:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801071e4:	e9 7b f4 ff ff       	jmp    80106664 <alltraps>

801071e9 <vector144>:
.globl vector144
vector144:
  pushl $0
801071e9:	6a 00                	push   $0x0
  pushl $144
801071eb:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801071f0:	e9 6f f4 ff ff       	jmp    80106664 <alltraps>

801071f5 <vector145>:
.globl vector145
vector145:
  pushl $0
801071f5:	6a 00                	push   $0x0
  pushl $145
801071f7:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801071fc:	e9 63 f4 ff ff       	jmp    80106664 <alltraps>

80107201 <vector146>:
.globl vector146
vector146:
  pushl $0
80107201:	6a 00                	push   $0x0
  pushl $146
80107203:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107208:	e9 57 f4 ff ff       	jmp    80106664 <alltraps>

8010720d <vector147>:
.globl vector147
vector147:
  pushl $0
8010720d:	6a 00                	push   $0x0
  pushl $147
8010720f:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107214:	e9 4b f4 ff ff       	jmp    80106664 <alltraps>

80107219 <vector148>:
.globl vector148
vector148:
  pushl $0
80107219:	6a 00                	push   $0x0
  pushl $148
8010721b:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107220:	e9 3f f4 ff ff       	jmp    80106664 <alltraps>

80107225 <vector149>:
.globl vector149
vector149:
  pushl $0
80107225:	6a 00                	push   $0x0
  pushl $149
80107227:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010722c:	e9 33 f4 ff ff       	jmp    80106664 <alltraps>

80107231 <vector150>:
.globl vector150
vector150:
  pushl $0
80107231:	6a 00                	push   $0x0
  pushl $150
80107233:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107238:	e9 27 f4 ff ff       	jmp    80106664 <alltraps>

8010723d <vector151>:
.globl vector151
vector151:
  pushl $0
8010723d:	6a 00                	push   $0x0
  pushl $151
8010723f:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107244:	e9 1b f4 ff ff       	jmp    80106664 <alltraps>

80107249 <vector152>:
.globl vector152
vector152:
  pushl $0
80107249:	6a 00                	push   $0x0
  pushl $152
8010724b:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107250:	e9 0f f4 ff ff       	jmp    80106664 <alltraps>

80107255 <vector153>:
.globl vector153
vector153:
  pushl $0
80107255:	6a 00                	push   $0x0
  pushl $153
80107257:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010725c:	e9 03 f4 ff ff       	jmp    80106664 <alltraps>

80107261 <vector154>:
.globl vector154
vector154:
  pushl $0
80107261:	6a 00                	push   $0x0
  pushl $154
80107263:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107268:	e9 f7 f3 ff ff       	jmp    80106664 <alltraps>

8010726d <vector155>:
.globl vector155
vector155:
  pushl $0
8010726d:	6a 00                	push   $0x0
  pushl $155
8010726f:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107274:	e9 eb f3 ff ff       	jmp    80106664 <alltraps>

80107279 <vector156>:
.globl vector156
vector156:
  pushl $0
80107279:	6a 00                	push   $0x0
  pushl $156
8010727b:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107280:	e9 df f3 ff ff       	jmp    80106664 <alltraps>

80107285 <vector157>:
.globl vector157
vector157:
  pushl $0
80107285:	6a 00                	push   $0x0
  pushl $157
80107287:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010728c:	e9 d3 f3 ff ff       	jmp    80106664 <alltraps>

80107291 <vector158>:
.globl vector158
vector158:
  pushl $0
80107291:	6a 00                	push   $0x0
  pushl $158
80107293:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107298:	e9 c7 f3 ff ff       	jmp    80106664 <alltraps>

8010729d <vector159>:
.globl vector159
vector159:
  pushl $0
8010729d:	6a 00                	push   $0x0
  pushl $159
8010729f:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801072a4:	e9 bb f3 ff ff       	jmp    80106664 <alltraps>

801072a9 <vector160>:
.globl vector160
vector160:
  pushl $0
801072a9:	6a 00                	push   $0x0
  pushl $160
801072ab:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801072b0:	e9 af f3 ff ff       	jmp    80106664 <alltraps>

801072b5 <vector161>:
.globl vector161
vector161:
  pushl $0
801072b5:	6a 00                	push   $0x0
  pushl $161
801072b7:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801072bc:	e9 a3 f3 ff ff       	jmp    80106664 <alltraps>

801072c1 <vector162>:
.globl vector162
vector162:
  pushl $0
801072c1:	6a 00                	push   $0x0
  pushl $162
801072c3:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801072c8:	e9 97 f3 ff ff       	jmp    80106664 <alltraps>

801072cd <vector163>:
.globl vector163
vector163:
  pushl $0
801072cd:	6a 00                	push   $0x0
  pushl $163
801072cf:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801072d4:	e9 8b f3 ff ff       	jmp    80106664 <alltraps>

801072d9 <vector164>:
.globl vector164
vector164:
  pushl $0
801072d9:	6a 00                	push   $0x0
  pushl $164
801072db:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801072e0:	e9 7f f3 ff ff       	jmp    80106664 <alltraps>

801072e5 <vector165>:
.globl vector165
vector165:
  pushl $0
801072e5:	6a 00                	push   $0x0
  pushl $165
801072e7:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801072ec:	e9 73 f3 ff ff       	jmp    80106664 <alltraps>

801072f1 <vector166>:
.globl vector166
vector166:
  pushl $0
801072f1:	6a 00                	push   $0x0
  pushl $166
801072f3:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801072f8:	e9 67 f3 ff ff       	jmp    80106664 <alltraps>

801072fd <vector167>:
.globl vector167
vector167:
  pushl $0
801072fd:	6a 00                	push   $0x0
  pushl $167
801072ff:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107304:	e9 5b f3 ff ff       	jmp    80106664 <alltraps>

80107309 <vector168>:
.globl vector168
vector168:
  pushl $0
80107309:	6a 00                	push   $0x0
  pushl $168
8010730b:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107310:	e9 4f f3 ff ff       	jmp    80106664 <alltraps>

80107315 <vector169>:
.globl vector169
vector169:
  pushl $0
80107315:	6a 00                	push   $0x0
  pushl $169
80107317:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010731c:	e9 43 f3 ff ff       	jmp    80106664 <alltraps>

80107321 <vector170>:
.globl vector170
vector170:
  pushl $0
80107321:	6a 00                	push   $0x0
  pushl $170
80107323:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107328:	e9 37 f3 ff ff       	jmp    80106664 <alltraps>

8010732d <vector171>:
.globl vector171
vector171:
  pushl $0
8010732d:	6a 00                	push   $0x0
  pushl $171
8010732f:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107334:	e9 2b f3 ff ff       	jmp    80106664 <alltraps>

80107339 <vector172>:
.globl vector172
vector172:
  pushl $0
80107339:	6a 00                	push   $0x0
  pushl $172
8010733b:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107340:	e9 1f f3 ff ff       	jmp    80106664 <alltraps>

80107345 <vector173>:
.globl vector173
vector173:
  pushl $0
80107345:	6a 00                	push   $0x0
  pushl $173
80107347:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010734c:	e9 13 f3 ff ff       	jmp    80106664 <alltraps>

80107351 <vector174>:
.globl vector174
vector174:
  pushl $0
80107351:	6a 00                	push   $0x0
  pushl $174
80107353:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107358:	e9 07 f3 ff ff       	jmp    80106664 <alltraps>

8010735d <vector175>:
.globl vector175
vector175:
  pushl $0
8010735d:	6a 00                	push   $0x0
  pushl $175
8010735f:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107364:	e9 fb f2 ff ff       	jmp    80106664 <alltraps>

80107369 <vector176>:
.globl vector176
vector176:
  pushl $0
80107369:	6a 00                	push   $0x0
  pushl $176
8010736b:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107370:	e9 ef f2 ff ff       	jmp    80106664 <alltraps>

80107375 <vector177>:
.globl vector177
vector177:
  pushl $0
80107375:	6a 00                	push   $0x0
  pushl $177
80107377:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010737c:	e9 e3 f2 ff ff       	jmp    80106664 <alltraps>

80107381 <vector178>:
.globl vector178
vector178:
  pushl $0
80107381:	6a 00                	push   $0x0
  pushl $178
80107383:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107388:	e9 d7 f2 ff ff       	jmp    80106664 <alltraps>

8010738d <vector179>:
.globl vector179
vector179:
  pushl $0
8010738d:	6a 00                	push   $0x0
  pushl $179
8010738f:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107394:	e9 cb f2 ff ff       	jmp    80106664 <alltraps>

80107399 <vector180>:
.globl vector180
vector180:
  pushl $0
80107399:	6a 00                	push   $0x0
  pushl $180
8010739b:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801073a0:	e9 bf f2 ff ff       	jmp    80106664 <alltraps>

801073a5 <vector181>:
.globl vector181
vector181:
  pushl $0
801073a5:	6a 00                	push   $0x0
  pushl $181
801073a7:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801073ac:	e9 b3 f2 ff ff       	jmp    80106664 <alltraps>

801073b1 <vector182>:
.globl vector182
vector182:
  pushl $0
801073b1:	6a 00                	push   $0x0
  pushl $182
801073b3:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801073b8:	e9 a7 f2 ff ff       	jmp    80106664 <alltraps>

801073bd <vector183>:
.globl vector183
vector183:
  pushl $0
801073bd:	6a 00                	push   $0x0
  pushl $183
801073bf:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801073c4:	e9 9b f2 ff ff       	jmp    80106664 <alltraps>

801073c9 <vector184>:
.globl vector184
vector184:
  pushl $0
801073c9:	6a 00                	push   $0x0
  pushl $184
801073cb:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801073d0:	e9 8f f2 ff ff       	jmp    80106664 <alltraps>

801073d5 <vector185>:
.globl vector185
vector185:
  pushl $0
801073d5:	6a 00                	push   $0x0
  pushl $185
801073d7:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801073dc:	e9 83 f2 ff ff       	jmp    80106664 <alltraps>

801073e1 <vector186>:
.globl vector186
vector186:
  pushl $0
801073e1:	6a 00                	push   $0x0
  pushl $186
801073e3:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801073e8:	e9 77 f2 ff ff       	jmp    80106664 <alltraps>

801073ed <vector187>:
.globl vector187
vector187:
  pushl $0
801073ed:	6a 00                	push   $0x0
  pushl $187
801073ef:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801073f4:	e9 6b f2 ff ff       	jmp    80106664 <alltraps>

801073f9 <vector188>:
.globl vector188
vector188:
  pushl $0
801073f9:	6a 00                	push   $0x0
  pushl $188
801073fb:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107400:	e9 5f f2 ff ff       	jmp    80106664 <alltraps>

80107405 <vector189>:
.globl vector189
vector189:
  pushl $0
80107405:	6a 00                	push   $0x0
  pushl $189
80107407:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010740c:	e9 53 f2 ff ff       	jmp    80106664 <alltraps>

80107411 <vector190>:
.globl vector190
vector190:
  pushl $0
80107411:	6a 00                	push   $0x0
  pushl $190
80107413:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107418:	e9 47 f2 ff ff       	jmp    80106664 <alltraps>

8010741d <vector191>:
.globl vector191
vector191:
  pushl $0
8010741d:	6a 00                	push   $0x0
  pushl $191
8010741f:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107424:	e9 3b f2 ff ff       	jmp    80106664 <alltraps>

80107429 <vector192>:
.globl vector192
vector192:
  pushl $0
80107429:	6a 00                	push   $0x0
  pushl $192
8010742b:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107430:	e9 2f f2 ff ff       	jmp    80106664 <alltraps>

80107435 <vector193>:
.globl vector193
vector193:
  pushl $0
80107435:	6a 00                	push   $0x0
  pushl $193
80107437:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010743c:	e9 23 f2 ff ff       	jmp    80106664 <alltraps>

80107441 <vector194>:
.globl vector194
vector194:
  pushl $0
80107441:	6a 00                	push   $0x0
  pushl $194
80107443:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107448:	e9 17 f2 ff ff       	jmp    80106664 <alltraps>

8010744d <vector195>:
.globl vector195
vector195:
  pushl $0
8010744d:	6a 00                	push   $0x0
  pushl $195
8010744f:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107454:	e9 0b f2 ff ff       	jmp    80106664 <alltraps>

80107459 <vector196>:
.globl vector196
vector196:
  pushl $0
80107459:	6a 00                	push   $0x0
  pushl $196
8010745b:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107460:	e9 ff f1 ff ff       	jmp    80106664 <alltraps>

80107465 <vector197>:
.globl vector197
vector197:
  pushl $0
80107465:	6a 00                	push   $0x0
  pushl $197
80107467:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010746c:	e9 f3 f1 ff ff       	jmp    80106664 <alltraps>

80107471 <vector198>:
.globl vector198
vector198:
  pushl $0
80107471:	6a 00                	push   $0x0
  pushl $198
80107473:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107478:	e9 e7 f1 ff ff       	jmp    80106664 <alltraps>

8010747d <vector199>:
.globl vector199
vector199:
  pushl $0
8010747d:	6a 00                	push   $0x0
  pushl $199
8010747f:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107484:	e9 db f1 ff ff       	jmp    80106664 <alltraps>

80107489 <vector200>:
.globl vector200
vector200:
  pushl $0
80107489:	6a 00                	push   $0x0
  pushl $200
8010748b:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107490:	e9 cf f1 ff ff       	jmp    80106664 <alltraps>

80107495 <vector201>:
.globl vector201
vector201:
  pushl $0
80107495:	6a 00                	push   $0x0
  pushl $201
80107497:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010749c:	e9 c3 f1 ff ff       	jmp    80106664 <alltraps>

801074a1 <vector202>:
.globl vector202
vector202:
  pushl $0
801074a1:	6a 00                	push   $0x0
  pushl $202
801074a3:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801074a8:	e9 b7 f1 ff ff       	jmp    80106664 <alltraps>

801074ad <vector203>:
.globl vector203
vector203:
  pushl $0
801074ad:	6a 00                	push   $0x0
  pushl $203
801074af:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801074b4:	e9 ab f1 ff ff       	jmp    80106664 <alltraps>

801074b9 <vector204>:
.globl vector204
vector204:
  pushl $0
801074b9:	6a 00                	push   $0x0
  pushl $204
801074bb:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801074c0:	e9 9f f1 ff ff       	jmp    80106664 <alltraps>

801074c5 <vector205>:
.globl vector205
vector205:
  pushl $0
801074c5:	6a 00                	push   $0x0
  pushl $205
801074c7:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801074cc:	e9 93 f1 ff ff       	jmp    80106664 <alltraps>

801074d1 <vector206>:
.globl vector206
vector206:
  pushl $0
801074d1:	6a 00                	push   $0x0
  pushl $206
801074d3:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801074d8:	e9 87 f1 ff ff       	jmp    80106664 <alltraps>

801074dd <vector207>:
.globl vector207
vector207:
  pushl $0
801074dd:	6a 00                	push   $0x0
  pushl $207
801074df:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801074e4:	e9 7b f1 ff ff       	jmp    80106664 <alltraps>

801074e9 <vector208>:
.globl vector208
vector208:
  pushl $0
801074e9:	6a 00                	push   $0x0
  pushl $208
801074eb:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801074f0:	e9 6f f1 ff ff       	jmp    80106664 <alltraps>

801074f5 <vector209>:
.globl vector209
vector209:
  pushl $0
801074f5:	6a 00                	push   $0x0
  pushl $209
801074f7:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801074fc:	e9 63 f1 ff ff       	jmp    80106664 <alltraps>

80107501 <vector210>:
.globl vector210
vector210:
  pushl $0
80107501:	6a 00                	push   $0x0
  pushl $210
80107503:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107508:	e9 57 f1 ff ff       	jmp    80106664 <alltraps>

8010750d <vector211>:
.globl vector211
vector211:
  pushl $0
8010750d:	6a 00                	push   $0x0
  pushl $211
8010750f:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107514:	e9 4b f1 ff ff       	jmp    80106664 <alltraps>

80107519 <vector212>:
.globl vector212
vector212:
  pushl $0
80107519:	6a 00                	push   $0x0
  pushl $212
8010751b:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107520:	e9 3f f1 ff ff       	jmp    80106664 <alltraps>

80107525 <vector213>:
.globl vector213
vector213:
  pushl $0
80107525:	6a 00                	push   $0x0
  pushl $213
80107527:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010752c:	e9 33 f1 ff ff       	jmp    80106664 <alltraps>

80107531 <vector214>:
.globl vector214
vector214:
  pushl $0
80107531:	6a 00                	push   $0x0
  pushl $214
80107533:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107538:	e9 27 f1 ff ff       	jmp    80106664 <alltraps>

8010753d <vector215>:
.globl vector215
vector215:
  pushl $0
8010753d:	6a 00                	push   $0x0
  pushl $215
8010753f:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107544:	e9 1b f1 ff ff       	jmp    80106664 <alltraps>

80107549 <vector216>:
.globl vector216
vector216:
  pushl $0
80107549:	6a 00                	push   $0x0
  pushl $216
8010754b:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107550:	e9 0f f1 ff ff       	jmp    80106664 <alltraps>

80107555 <vector217>:
.globl vector217
vector217:
  pushl $0
80107555:	6a 00                	push   $0x0
  pushl $217
80107557:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010755c:	e9 03 f1 ff ff       	jmp    80106664 <alltraps>

80107561 <vector218>:
.globl vector218
vector218:
  pushl $0
80107561:	6a 00                	push   $0x0
  pushl $218
80107563:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107568:	e9 f7 f0 ff ff       	jmp    80106664 <alltraps>

8010756d <vector219>:
.globl vector219
vector219:
  pushl $0
8010756d:	6a 00                	push   $0x0
  pushl $219
8010756f:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107574:	e9 eb f0 ff ff       	jmp    80106664 <alltraps>

80107579 <vector220>:
.globl vector220
vector220:
  pushl $0
80107579:	6a 00                	push   $0x0
  pushl $220
8010757b:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107580:	e9 df f0 ff ff       	jmp    80106664 <alltraps>

80107585 <vector221>:
.globl vector221
vector221:
  pushl $0
80107585:	6a 00                	push   $0x0
  pushl $221
80107587:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010758c:	e9 d3 f0 ff ff       	jmp    80106664 <alltraps>

80107591 <vector222>:
.globl vector222
vector222:
  pushl $0
80107591:	6a 00                	push   $0x0
  pushl $222
80107593:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107598:	e9 c7 f0 ff ff       	jmp    80106664 <alltraps>

8010759d <vector223>:
.globl vector223
vector223:
  pushl $0
8010759d:	6a 00                	push   $0x0
  pushl $223
8010759f:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801075a4:	e9 bb f0 ff ff       	jmp    80106664 <alltraps>

801075a9 <vector224>:
.globl vector224
vector224:
  pushl $0
801075a9:	6a 00                	push   $0x0
  pushl $224
801075ab:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801075b0:	e9 af f0 ff ff       	jmp    80106664 <alltraps>

801075b5 <vector225>:
.globl vector225
vector225:
  pushl $0
801075b5:	6a 00                	push   $0x0
  pushl $225
801075b7:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801075bc:	e9 a3 f0 ff ff       	jmp    80106664 <alltraps>

801075c1 <vector226>:
.globl vector226
vector226:
  pushl $0
801075c1:	6a 00                	push   $0x0
  pushl $226
801075c3:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801075c8:	e9 97 f0 ff ff       	jmp    80106664 <alltraps>

801075cd <vector227>:
.globl vector227
vector227:
  pushl $0
801075cd:	6a 00                	push   $0x0
  pushl $227
801075cf:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801075d4:	e9 8b f0 ff ff       	jmp    80106664 <alltraps>

801075d9 <vector228>:
.globl vector228
vector228:
  pushl $0
801075d9:	6a 00                	push   $0x0
  pushl $228
801075db:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801075e0:	e9 7f f0 ff ff       	jmp    80106664 <alltraps>

801075e5 <vector229>:
.globl vector229
vector229:
  pushl $0
801075e5:	6a 00                	push   $0x0
  pushl $229
801075e7:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801075ec:	e9 73 f0 ff ff       	jmp    80106664 <alltraps>

801075f1 <vector230>:
.globl vector230
vector230:
  pushl $0
801075f1:	6a 00                	push   $0x0
  pushl $230
801075f3:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801075f8:	e9 67 f0 ff ff       	jmp    80106664 <alltraps>

801075fd <vector231>:
.globl vector231
vector231:
  pushl $0
801075fd:	6a 00                	push   $0x0
  pushl $231
801075ff:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107604:	e9 5b f0 ff ff       	jmp    80106664 <alltraps>

80107609 <vector232>:
.globl vector232
vector232:
  pushl $0
80107609:	6a 00                	push   $0x0
  pushl $232
8010760b:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107610:	e9 4f f0 ff ff       	jmp    80106664 <alltraps>

80107615 <vector233>:
.globl vector233
vector233:
  pushl $0
80107615:	6a 00                	push   $0x0
  pushl $233
80107617:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010761c:	e9 43 f0 ff ff       	jmp    80106664 <alltraps>

80107621 <vector234>:
.globl vector234
vector234:
  pushl $0
80107621:	6a 00                	push   $0x0
  pushl $234
80107623:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107628:	e9 37 f0 ff ff       	jmp    80106664 <alltraps>

8010762d <vector235>:
.globl vector235
vector235:
  pushl $0
8010762d:	6a 00                	push   $0x0
  pushl $235
8010762f:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107634:	e9 2b f0 ff ff       	jmp    80106664 <alltraps>

80107639 <vector236>:
.globl vector236
vector236:
  pushl $0
80107639:	6a 00                	push   $0x0
  pushl $236
8010763b:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107640:	e9 1f f0 ff ff       	jmp    80106664 <alltraps>

80107645 <vector237>:
.globl vector237
vector237:
  pushl $0
80107645:	6a 00                	push   $0x0
  pushl $237
80107647:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010764c:	e9 13 f0 ff ff       	jmp    80106664 <alltraps>

80107651 <vector238>:
.globl vector238
vector238:
  pushl $0
80107651:	6a 00                	push   $0x0
  pushl $238
80107653:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107658:	e9 07 f0 ff ff       	jmp    80106664 <alltraps>

8010765d <vector239>:
.globl vector239
vector239:
  pushl $0
8010765d:	6a 00                	push   $0x0
  pushl $239
8010765f:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107664:	e9 fb ef ff ff       	jmp    80106664 <alltraps>

80107669 <vector240>:
.globl vector240
vector240:
  pushl $0
80107669:	6a 00                	push   $0x0
  pushl $240
8010766b:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107670:	e9 ef ef ff ff       	jmp    80106664 <alltraps>

80107675 <vector241>:
.globl vector241
vector241:
  pushl $0
80107675:	6a 00                	push   $0x0
  pushl $241
80107677:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010767c:	e9 e3 ef ff ff       	jmp    80106664 <alltraps>

80107681 <vector242>:
.globl vector242
vector242:
  pushl $0
80107681:	6a 00                	push   $0x0
  pushl $242
80107683:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107688:	e9 d7 ef ff ff       	jmp    80106664 <alltraps>

8010768d <vector243>:
.globl vector243
vector243:
  pushl $0
8010768d:	6a 00                	push   $0x0
  pushl $243
8010768f:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107694:	e9 cb ef ff ff       	jmp    80106664 <alltraps>

80107699 <vector244>:
.globl vector244
vector244:
  pushl $0
80107699:	6a 00                	push   $0x0
  pushl $244
8010769b:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801076a0:	e9 bf ef ff ff       	jmp    80106664 <alltraps>

801076a5 <vector245>:
.globl vector245
vector245:
  pushl $0
801076a5:	6a 00                	push   $0x0
  pushl $245
801076a7:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801076ac:	e9 b3 ef ff ff       	jmp    80106664 <alltraps>

801076b1 <vector246>:
.globl vector246
vector246:
  pushl $0
801076b1:	6a 00                	push   $0x0
  pushl $246
801076b3:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801076b8:	e9 a7 ef ff ff       	jmp    80106664 <alltraps>

801076bd <vector247>:
.globl vector247
vector247:
  pushl $0
801076bd:	6a 00                	push   $0x0
  pushl $247
801076bf:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801076c4:	e9 9b ef ff ff       	jmp    80106664 <alltraps>

801076c9 <vector248>:
.globl vector248
vector248:
  pushl $0
801076c9:	6a 00                	push   $0x0
  pushl $248
801076cb:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801076d0:	e9 8f ef ff ff       	jmp    80106664 <alltraps>

801076d5 <vector249>:
.globl vector249
vector249:
  pushl $0
801076d5:	6a 00                	push   $0x0
  pushl $249
801076d7:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801076dc:	e9 83 ef ff ff       	jmp    80106664 <alltraps>

801076e1 <vector250>:
.globl vector250
vector250:
  pushl $0
801076e1:	6a 00                	push   $0x0
  pushl $250
801076e3:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801076e8:	e9 77 ef ff ff       	jmp    80106664 <alltraps>

801076ed <vector251>:
.globl vector251
vector251:
  pushl $0
801076ed:	6a 00                	push   $0x0
  pushl $251
801076ef:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801076f4:	e9 6b ef ff ff       	jmp    80106664 <alltraps>

801076f9 <vector252>:
.globl vector252
vector252:
  pushl $0
801076f9:	6a 00                	push   $0x0
  pushl $252
801076fb:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107700:	e9 5f ef ff ff       	jmp    80106664 <alltraps>

80107705 <vector253>:
.globl vector253
vector253:
  pushl $0
80107705:	6a 00                	push   $0x0
  pushl $253
80107707:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010770c:	e9 53 ef ff ff       	jmp    80106664 <alltraps>

80107711 <vector254>:
.globl vector254
vector254:
  pushl $0
80107711:	6a 00                	push   $0x0
  pushl $254
80107713:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107718:	e9 47 ef ff ff       	jmp    80106664 <alltraps>

8010771d <vector255>:
.globl vector255
vector255:
  pushl $0
8010771d:	6a 00                	push   $0x0
  pushl $255
8010771f:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107724:	e9 3b ef ff ff       	jmp    80106664 <alltraps>

80107729 <lgdt>:
{
80107729:	55                   	push   %ebp
8010772a:	89 e5                	mov    %esp,%ebp
8010772c:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
8010772f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107732:	83 e8 01             	sub    $0x1,%eax
80107735:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107739:	8b 45 08             	mov    0x8(%ebp),%eax
8010773c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107740:	8b 45 08             	mov    0x8(%ebp),%eax
80107743:	c1 e8 10             	shr    $0x10,%eax
80107746:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010774a:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010774d:	0f 01 10             	lgdtl  (%eax)
}
80107750:	90                   	nop
80107751:	c9                   	leave  
80107752:	c3                   	ret    

80107753 <ltr>:
{
80107753:	55                   	push   %ebp
80107754:	89 e5                	mov    %esp,%ebp
80107756:	83 ec 04             	sub    $0x4,%esp
80107759:	8b 45 08             	mov    0x8(%ebp),%eax
8010775c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107760:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107764:	0f 00 d8             	ltr    %ax
}
80107767:	90                   	nop
80107768:	c9                   	leave  
80107769:	c3                   	ret    

8010776a <loadgs>:
{
8010776a:	55                   	push   %ebp
8010776b:	89 e5                	mov    %esp,%ebp
8010776d:	83 ec 04             	sub    $0x4,%esp
80107770:	8b 45 08             	mov    0x8(%ebp),%eax
80107773:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107777:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010777b:	8e e8                	mov    %eax,%gs
}
8010777d:	90                   	nop
8010777e:	c9                   	leave  
8010777f:	c3                   	ret    

80107780 <lcr3>:
{
80107780:	55                   	push   %ebp
80107781:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107783:	8b 45 08             	mov    0x8(%ebp),%eax
80107786:	0f 22 d8             	mov    %eax,%cr3
}
80107789:	90                   	nop
8010778a:	5d                   	pop    %ebp
8010778b:	c3                   	ret    

8010778c <v2p>:
static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
8010778c:	55                   	push   %ebp
8010778d:	89 e5                	mov    %esp,%ebp
8010778f:	8b 45 08             	mov    0x8(%ebp),%eax
80107792:	05 00 00 00 80       	add    $0x80000000,%eax
80107797:	5d                   	pop    %ebp
80107798:	c3                   	ret    

80107799 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107799:	55                   	push   %ebp
8010779a:	89 e5                	mov    %esp,%ebp
8010779c:	8b 45 08             	mov    0x8(%ebp),%eax
8010779f:	05 00 00 00 80       	add    $0x80000000,%eax
801077a4:	5d                   	pop    %ebp
801077a5:	c3                   	ret    

801077a6 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801077a6:	55                   	push   %ebp
801077a7:	89 e5                	mov    %esp,%ebp
801077a9:	53                   	push   %ebx
801077aa:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801077ad:	e8 21 b8 ff ff       	call   80102fd3 <cpunum>
801077b2:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801077b8:	05 60 23 11 80       	add    $0x80112360,%eax
801077bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801077c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077c3:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801077c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077cc:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801077d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077d5:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801077d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077dc:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801077e0:	83 e2 f0             	and    $0xfffffff0,%edx
801077e3:	83 ca 0a             	or     $0xa,%edx
801077e6:	88 50 7d             	mov    %dl,0x7d(%eax)
801077e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077ec:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801077f0:	83 ca 10             	or     $0x10,%edx
801077f3:	88 50 7d             	mov    %dl,0x7d(%eax)
801077f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f9:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801077fd:	83 e2 9f             	and    $0xffffff9f,%edx
80107800:	88 50 7d             	mov    %dl,0x7d(%eax)
80107803:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107806:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010780a:	83 ca 80             	or     $0xffffff80,%edx
8010780d:	88 50 7d             	mov    %dl,0x7d(%eax)
80107810:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107813:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107817:	83 ca 0f             	or     $0xf,%edx
8010781a:	88 50 7e             	mov    %dl,0x7e(%eax)
8010781d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107820:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107824:	83 e2 ef             	and    $0xffffffef,%edx
80107827:	88 50 7e             	mov    %dl,0x7e(%eax)
8010782a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010782d:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107831:	83 e2 df             	and    $0xffffffdf,%edx
80107834:	88 50 7e             	mov    %dl,0x7e(%eax)
80107837:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010783a:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010783e:	83 ca 40             	or     $0x40,%edx
80107841:	88 50 7e             	mov    %dl,0x7e(%eax)
80107844:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107847:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010784b:	83 ca 80             	or     $0xffffff80,%edx
8010784e:	88 50 7e             	mov    %dl,0x7e(%eax)
80107851:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107854:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107858:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010785b:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107862:	ff ff 
80107864:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107867:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010786e:	00 00 
80107870:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107873:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
8010787a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010787d:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107884:	83 e2 f0             	and    $0xfffffff0,%edx
80107887:	83 ca 02             	or     $0x2,%edx
8010788a:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107890:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107893:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010789a:	83 ca 10             	or     $0x10,%edx
8010789d:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801078a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078a6:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801078ad:	83 e2 9f             	and    $0xffffff9f,%edx
801078b0:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801078b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078b9:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801078c0:	83 ca 80             	or     $0xffffff80,%edx
801078c3:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801078c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078cc:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801078d3:	83 ca 0f             	or     $0xf,%edx
801078d6:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801078dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078df:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801078e6:	83 e2 ef             	and    $0xffffffef,%edx
801078e9:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801078ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f2:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801078f9:	83 e2 df             	and    $0xffffffdf,%edx
801078fc:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107902:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107905:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010790c:	83 ca 40             	or     $0x40,%edx
8010790f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107915:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107918:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010791f:	83 ca 80             	or     $0xffffff80,%edx
80107922:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107928:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010792b:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107932:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107935:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010793c:	ff ff 
8010793e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107941:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107948:	00 00 
8010794a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010794d:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107954:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107957:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010795e:	83 e2 f0             	and    $0xfffffff0,%edx
80107961:	83 ca 0a             	or     $0xa,%edx
80107964:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010796a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010796d:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107974:	83 ca 10             	or     $0x10,%edx
80107977:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010797d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107980:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107987:	83 ca 60             	or     $0x60,%edx
8010798a:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107990:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107993:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010799a:	83 ca 80             	or     $0xffffff80,%edx
8010799d:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801079a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079a6:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801079ad:	83 ca 0f             	or     $0xf,%edx
801079b0:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801079b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079b9:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801079c0:	83 e2 ef             	and    $0xffffffef,%edx
801079c3:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801079c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079cc:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801079d3:	83 e2 df             	and    $0xffffffdf,%edx
801079d6:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801079dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079df:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801079e6:	83 ca 40             	or     $0x40,%edx
801079e9:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801079ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f2:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801079f9:	83 ca 80             	or     $0xffffff80,%edx
801079fc:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a05:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a0f:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107a16:	ff ff 
80107a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a1b:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107a22:	00 00 
80107a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a27:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a31:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107a38:	83 e2 f0             	and    $0xfffffff0,%edx
80107a3b:	83 ca 02             	or     $0x2,%edx
80107a3e:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a47:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107a4e:	83 ca 10             	or     $0x10,%edx
80107a51:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a5a:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107a61:	83 ca 60             	or     $0x60,%edx
80107a64:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a6d:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107a74:	83 ca 80             	or     $0xffffff80,%edx
80107a77:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a80:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107a87:	83 ca 0f             	or     $0xf,%edx
80107a8a:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a93:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107a9a:	83 e2 ef             	and    $0xffffffef,%edx
80107a9d:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa6:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107aad:	83 e2 df             	and    $0xffffffdf,%edx
80107ab0:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ab9:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107ac0:	83 ca 40             	or     $0x40,%edx
80107ac3:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107acc:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107ad3:	83 ca 80             	or     $0xffffff80,%edx
80107ad6:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107adf:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ae9:	05 b4 00 00 00       	add    $0xb4,%eax
80107aee:	89 c3                	mov    %eax,%ebx
80107af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af3:	05 b4 00 00 00       	add    $0xb4,%eax
80107af8:	c1 e8 10             	shr    $0x10,%eax
80107afb:	89 c2                	mov    %eax,%edx
80107afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b00:	05 b4 00 00 00       	add    $0xb4,%eax
80107b05:	c1 e8 18             	shr    $0x18,%eax
80107b08:	89 c1                	mov    %eax,%ecx
80107b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b0d:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107b14:	00 00 
80107b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b19:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b23:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80107b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b2c:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107b33:	83 e2 f0             	and    $0xfffffff0,%edx
80107b36:	83 ca 02             	or     $0x2,%edx
80107b39:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b42:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107b49:	83 ca 10             	or     $0x10,%edx
80107b4c:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b55:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107b5c:	83 e2 9f             	and    $0xffffff9f,%edx
80107b5f:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b68:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107b6f:	83 ca 80             	or     $0xffffff80,%edx
80107b72:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b7b:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107b82:	83 e2 f0             	and    $0xfffffff0,%edx
80107b85:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b8e:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107b95:	83 e2 ef             	and    $0xffffffef,%edx
80107b98:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ba1:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107ba8:	83 e2 df             	and    $0xffffffdf,%edx
80107bab:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bb4:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107bbb:	83 ca 40             	or     $0x40,%edx
80107bbe:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bc7:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107bce:	83 ca 80             	or     $0xffffff80,%edx
80107bd1:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bda:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be3:	83 c0 70             	add    $0x70,%eax
80107be6:	83 ec 08             	sub    $0x8,%esp
80107be9:	6a 38                	push   $0x38
80107beb:	50                   	push   %eax
80107bec:	e8 38 fb ff ff       	call   80107729 <lgdt>
80107bf1:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80107bf4:	83 ec 0c             	sub    $0xc,%esp
80107bf7:	6a 18                	push   $0x18
80107bf9:	e8 6c fb ff ff       	call   8010776a <loadgs>
80107bfe:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80107c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c04:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107c0a:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107c11:	00 00 00 00 
}
80107c15:	90                   	nop
80107c16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107c19:	c9                   	leave  
80107c1a:	c3                   	ret    

80107c1b <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107c1b:	55                   	push   %ebp
80107c1c:	89 e5                	mov    %esp,%ebp
80107c1e:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107c21:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c24:	c1 e8 16             	shr    $0x16,%eax
80107c27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107c2e:	8b 45 08             	mov    0x8(%ebp),%eax
80107c31:	01 d0                	add    %edx,%eax
80107c33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c39:	8b 00                	mov    (%eax),%eax
80107c3b:	83 e0 01             	and    $0x1,%eax
80107c3e:	85 c0                	test   %eax,%eax
80107c40:	74 18                	je     80107c5a <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c45:	8b 00                	mov    (%eax),%eax
80107c47:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c4c:	50                   	push   %eax
80107c4d:	e8 47 fb ff ff       	call   80107799 <p2v>
80107c52:	83 c4 04             	add    $0x4,%esp
80107c55:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c58:	eb 48                	jmp    80107ca2 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107c5a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107c5e:	74 0e                	je     80107c6e <walkpgdir+0x53>
80107c60:	e8 05 b0 ff ff       	call   80102c6a <kalloc>
80107c65:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107c6c:	75 07                	jne    80107c75 <walkpgdir+0x5a>
      return 0;
80107c6e:	b8 00 00 00 00       	mov    $0x0,%eax
80107c73:	eb 44                	jmp    80107cb9 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107c75:	83 ec 04             	sub    $0x4,%esp
80107c78:	68 00 10 00 00       	push   $0x1000
80107c7d:	6a 00                	push   $0x0
80107c7f:	ff 75 f4             	pushl  -0xc(%ebp)
80107c82:	e8 20 d6 ff ff       	call   801052a7 <memset>
80107c87:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107c8a:	83 ec 0c             	sub    $0xc,%esp
80107c8d:	ff 75 f4             	pushl  -0xc(%ebp)
80107c90:	e8 f7 fa ff ff       	call   8010778c <v2p>
80107c95:	83 c4 10             	add    $0x10,%esp
80107c98:	83 c8 07             	or     $0x7,%eax
80107c9b:	89 c2                	mov    %eax,%edx
80107c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ca0:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ca5:	c1 e8 0c             	shr    $0xc,%eax
80107ca8:	25 ff 03 00 00       	and    $0x3ff,%eax
80107cad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cb7:	01 d0                	add    %edx,%eax
}
80107cb9:	c9                   	leave  
80107cba:	c3                   	ret    

80107cbb <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107cbb:	55                   	push   %ebp
80107cbc:	89 e5                	mov    %esp,%ebp
80107cbe:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cc4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107ccc:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ccf:	8b 45 10             	mov    0x10(%ebp),%eax
80107cd2:	01 d0                	add    %edx,%eax
80107cd4:	83 e8 01             	sub    $0x1,%eax
80107cd7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107cdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107cdf:	83 ec 04             	sub    $0x4,%esp
80107ce2:	6a 01                	push   $0x1
80107ce4:	ff 75 f4             	pushl  -0xc(%ebp)
80107ce7:	ff 75 08             	pushl  0x8(%ebp)
80107cea:	e8 2c ff ff ff       	call   80107c1b <walkpgdir>
80107cef:	83 c4 10             	add    $0x10,%esp
80107cf2:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107cf5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107cf9:	75 07                	jne    80107d02 <mappages+0x47>
      return -1;
80107cfb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d00:	eb 47                	jmp    80107d49 <mappages+0x8e>
    if(*pte & PTE_P)
80107d02:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d05:	8b 00                	mov    (%eax),%eax
80107d07:	83 e0 01             	and    $0x1,%eax
80107d0a:	85 c0                	test   %eax,%eax
80107d0c:	74 0d                	je     80107d1b <mappages+0x60>
      panic("remap");
80107d0e:	83 ec 0c             	sub    $0xc,%esp
80107d11:	68 98 8b 10 80       	push   $0x80108b98
80107d16:	e8 4c 88 ff ff       	call   80100567 <panic>
    *pte = pa | perm | PTE_P;
80107d1b:	8b 45 18             	mov    0x18(%ebp),%eax
80107d1e:	0b 45 14             	or     0x14(%ebp),%eax
80107d21:	83 c8 01             	or     $0x1,%eax
80107d24:	89 c2                	mov    %eax,%edx
80107d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d29:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d2e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107d31:	74 10                	je     80107d43 <mappages+0x88>
      break;
    a += PGSIZE;
80107d33:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107d3a:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107d41:	eb 9c                	jmp    80107cdf <mappages+0x24>
      break;
80107d43:	90                   	nop
  }
  return 0;
80107d44:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107d49:	c9                   	leave  
80107d4a:	c3                   	ret    

80107d4b <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107d4b:	55                   	push   %ebp
80107d4c:	89 e5                	mov    %esp,%ebp
80107d4e:	53                   	push   %ebx
80107d4f:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107d52:	e8 13 af ff ff       	call   80102c6a <kalloc>
80107d57:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107d5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107d5e:	75 0a                	jne    80107d6a <setupkvm+0x1f>
    return 0;
80107d60:	b8 00 00 00 00       	mov    $0x0,%eax
80107d65:	e9 8e 00 00 00       	jmp    80107df8 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80107d6a:	83 ec 04             	sub    $0x4,%esp
80107d6d:	68 00 10 00 00       	push   $0x1000
80107d72:	6a 00                	push   $0x0
80107d74:	ff 75 f0             	pushl  -0x10(%ebp)
80107d77:	e8 2b d5 ff ff       	call   801052a7 <memset>
80107d7c:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107d7f:	83 ec 0c             	sub    $0xc,%esp
80107d82:	68 00 00 00 0e       	push   $0xe000000
80107d87:	e8 0d fa ff ff       	call   80107799 <p2v>
80107d8c:	83 c4 10             	add    $0x10,%esp
80107d8f:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80107d94:	76 0d                	jbe    80107da3 <setupkvm+0x58>
    panic("PHYSTOP too high");
80107d96:	83 ec 0c             	sub    $0xc,%esp
80107d99:	68 9e 8b 10 80       	push   $0x80108b9e
80107d9e:	e8 c4 87 ff ff       	call   80100567 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107da3:	c7 45 f4 a0 b4 10 80 	movl   $0x8010b4a0,-0xc(%ebp)
80107daa:	eb 40                	jmp    80107dec <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107daf:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80107db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db5:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dbb:	8b 58 08             	mov    0x8(%eax),%ebx
80107dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dc1:	8b 40 04             	mov    0x4(%eax),%eax
80107dc4:	29 c3                	sub    %eax,%ebx
80107dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dc9:	8b 00                	mov    (%eax),%eax
80107dcb:	83 ec 0c             	sub    $0xc,%esp
80107dce:	51                   	push   %ecx
80107dcf:	52                   	push   %edx
80107dd0:	53                   	push   %ebx
80107dd1:	50                   	push   %eax
80107dd2:	ff 75 f0             	pushl  -0x10(%ebp)
80107dd5:	e8 e1 fe ff ff       	call   80107cbb <mappages>
80107dda:	83 c4 20             	add    $0x20,%esp
80107ddd:	85 c0                	test   %eax,%eax
80107ddf:	79 07                	jns    80107de8 <setupkvm+0x9d>
      return 0;
80107de1:	b8 00 00 00 00       	mov    $0x0,%eax
80107de6:	eb 10                	jmp    80107df8 <setupkvm+0xad>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107de8:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107dec:	81 7d f4 e0 b4 10 80 	cmpl   $0x8010b4e0,-0xc(%ebp)
80107df3:	72 b7                	jb     80107dac <setupkvm+0x61>
  return pgdir;
80107df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107df8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107dfb:	c9                   	leave  
80107dfc:	c3                   	ret    

80107dfd <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107dfd:	55                   	push   %ebp
80107dfe:	89 e5                	mov    %esp,%ebp
80107e00:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107e03:	e8 43 ff ff ff       	call   80107d4b <setupkvm>
80107e08:	a3 38 51 11 80       	mov    %eax,0x80115138
  switchkvm();
80107e0d:	e8 03 00 00 00       	call   80107e15 <switchkvm>
}
80107e12:	90                   	nop
80107e13:	c9                   	leave  
80107e14:	c3                   	ret    

80107e15 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107e15:	55                   	push   %ebp
80107e16:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107e18:	a1 38 51 11 80       	mov    0x80115138,%eax
80107e1d:	50                   	push   %eax
80107e1e:	e8 69 f9 ff ff       	call   8010778c <v2p>
80107e23:	83 c4 04             	add    $0x4,%esp
80107e26:	50                   	push   %eax
80107e27:	e8 54 f9 ff ff       	call   80107780 <lcr3>
80107e2c:	83 c4 04             	add    $0x4,%esp
}
80107e2f:	90                   	nop
80107e30:	c9                   	leave  
80107e31:	c3                   	ret    

80107e32 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107e32:	55                   	push   %ebp
80107e33:	89 e5                	mov    %esp,%ebp
80107e35:	56                   	push   %esi
80107e36:	53                   	push   %ebx
  pushcli();
80107e37:	e8 65 d3 ff ff       	call   801051a1 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107e3c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e42:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107e49:	83 c2 08             	add    $0x8,%edx
80107e4c:	89 d6                	mov    %edx,%esi
80107e4e:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107e55:	83 c2 08             	add    $0x8,%edx
80107e58:	c1 ea 10             	shr    $0x10,%edx
80107e5b:	89 d3                	mov    %edx,%ebx
80107e5d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107e64:	83 c2 08             	add    $0x8,%edx
80107e67:	c1 ea 18             	shr    $0x18,%edx
80107e6a:	89 d1                	mov    %edx,%ecx
80107e6c:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107e73:	67 00 
80107e75:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80107e7c:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80107e82:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107e89:	83 e2 f0             	and    $0xfffffff0,%edx
80107e8c:	83 ca 09             	or     $0x9,%edx
80107e8f:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107e95:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107e9c:	83 ca 10             	or     $0x10,%edx
80107e9f:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107ea5:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107eac:	83 e2 9f             	and    $0xffffff9f,%edx
80107eaf:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107eb5:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107ebc:	83 ca 80             	or     $0xffffff80,%edx
80107ebf:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107ec5:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107ecc:	83 e2 f0             	and    $0xfffffff0,%edx
80107ecf:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107ed5:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107edc:	83 e2 ef             	and    $0xffffffef,%edx
80107edf:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107ee5:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107eec:	83 e2 df             	and    $0xffffffdf,%edx
80107eef:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107ef5:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107efc:	83 ca 40             	or     $0x40,%edx
80107eff:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107f05:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107f0c:	83 e2 7f             	and    $0x7f,%edx
80107f0f:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107f15:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107f1b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107f21:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107f28:	83 e2 ef             	and    $0xffffffef,%edx
80107f2b:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107f31:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107f37:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107f3d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107f43:	8b 40 08             	mov    0x8(%eax),%eax
80107f46:	89 c2                	mov    %eax,%edx
80107f48:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107f4e:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107f54:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107f57:	83 ec 0c             	sub    $0xc,%esp
80107f5a:	6a 30                	push   $0x30
80107f5c:	e8 f2 f7 ff ff       	call   80107753 <ltr>
80107f61:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80107f64:	8b 45 08             	mov    0x8(%ebp),%eax
80107f67:	8b 40 04             	mov    0x4(%eax),%eax
80107f6a:	85 c0                	test   %eax,%eax
80107f6c:	75 0d                	jne    80107f7b <switchuvm+0x149>
    panic("switchuvm: no pgdir");
80107f6e:	83 ec 0c             	sub    $0xc,%esp
80107f71:	68 af 8b 10 80       	push   $0x80108baf
80107f76:	e8 ec 85 ff ff       	call   80100567 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107f7b:	8b 45 08             	mov    0x8(%ebp),%eax
80107f7e:	8b 40 04             	mov    0x4(%eax),%eax
80107f81:	83 ec 0c             	sub    $0xc,%esp
80107f84:	50                   	push   %eax
80107f85:	e8 02 f8 ff ff       	call   8010778c <v2p>
80107f8a:	83 c4 10             	add    $0x10,%esp
80107f8d:	83 ec 0c             	sub    $0xc,%esp
80107f90:	50                   	push   %eax
80107f91:	e8 ea f7 ff ff       	call   80107780 <lcr3>
80107f96:	83 c4 10             	add    $0x10,%esp
  popcli();
80107f99:	e8 48 d2 ff ff       	call   801051e6 <popcli>
}
80107f9e:	90                   	nop
80107f9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107fa2:	5b                   	pop    %ebx
80107fa3:	5e                   	pop    %esi
80107fa4:	5d                   	pop    %ebp
80107fa5:	c3                   	ret    

80107fa6 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107fa6:	55                   	push   %ebp
80107fa7:	89 e5                	mov    %esp,%ebp
80107fa9:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107fac:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107fb3:	76 0d                	jbe    80107fc2 <inituvm+0x1c>
    panic("inituvm: more than a page");
80107fb5:	83 ec 0c             	sub    $0xc,%esp
80107fb8:	68 c3 8b 10 80       	push   $0x80108bc3
80107fbd:	e8 a5 85 ff ff       	call   80100567 <panic>
  mem = kalloc();
80107fc2:	e8 a3 ac ff ff       	call   80102c6a <kalloc>
80107fc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107fca:	83 ec 04             	sub    $0x4,%esp
80107fcd:	68 00 10 00 00       	push   $0x1000
80107fd2:	6a 00                	push   $0x0
80107fd4:	ff 75 f4             	pushl  -0xc(%ebp)
80107fd7:	e8 cb d2 ff ff       	call   801052a7 <memset>
80107fdc:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107fdf:	83 ec 0c             	sub    $0xc,%esp
80107fe2:	ff 75 f4             	pushl  -0xc(%ebp)
80107fe5:	e8 a2 f7 ff ff       	call   8010778c <v2p>
80107fea:	83 c4 10             	add    $0x10,%esp
80107fed:	83 ec 0c             	sub    $0xc,%esp
80107ff0:	6a 06                	push   $0x6
80107ff2:	50                   	push   %eax
80107ff3:	68 00 10 00 00       	push   $0x1000
80107ff8:	6a 00                	push   $0x0
80107ffa:	ff 75 08             	pushl  0x8(%ebp)
80107ffd:	e8 b9 fc ff ff       	call   80107cbb <mappages>
80108002:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80108005:	83 ec 04             	sub    $0x4,%esp
80108008:	ff 75 10             	pushl  0x10(%ebp)
8010800b:	ff 75 0c             	pushl  0xc(%ebp)
8010800e:	ff 75 f4             	pushl  -0xc(%ebp)
80108011:	e8 50 d3 ff ff       	call   80105366 <memmove>
80108016:	83 c4 10             	add    $0x10,%esp
}
80108019:	90                   	nop
8010801a:	c9                   	leave  
8010801b:	c3                   	ret    

8010801c <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010801c:	55                   	push   %ebp
8010801d:	89 e5                	mov    %esp,%ebp
8010801f:	53                   	push   %ebx
80108020:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108023:	8b 45 0c             	mov    0xc(%ebp),%eax
80108026:	25 ff 0f 00 00       	and    $0xfff,%eax
8010802b:	85 c0                	test   %eax,%eax
8010802d:	74 0d                	je     8010803c <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
8010802f:	83 ec 0c             	sub    $0xc,%esp
80108032:	68 e0 8b 10 80       	push   $0x80108be0
80108037:	e8 2b 85 ff ff       	call   80100567 <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010803c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108043:	e9 95 00 00 00       	jmp    801080dd <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108048:	8b 55 0c             	mov    0xc(%ebp),%edx
8010804b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010804e:	01 d0                	add    %edx,%eax
80108050:	83 ec 04             	sub    $0x4,%esp
80108053:	6a 00                	push   $0x0
80108055:	50                   	push   %eax
80108056:	ff 75 08             	pushl  0x8(%ebp)
80108059:	e8 bd fb ff ff       	call   80107c1b <walkpgdir>
8010805e:	83 c4 10             	add    $0x10,%esp
80108061:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108064:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108068:	75 0d                	jne    80108077 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
8010806a:	83 ec 0c             	sub    $0xc,%esp
8010806d:	68 03 8c 10 80       	push   $0x80108c03
80108072:	e8 f0 84 ff ff       	call   80100567 <panic>
    pa = PTE_ADDR(*pte);
80108077:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010807a:	8b 00                	mov    (%eax),%eax
8010807c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108081:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108084:	8b 45 18             	mov    0x18(%ebp),%eax
80108087:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010808a:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010808f:	77 0b                	ja     8010809c <loaduvm+0x80>
      n = sz - i;
80108091:	8b 45 18             	mov    0x18(%ebp),%eax
80108094:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108097:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010809a:	eb 07                	jmp    801080a3 <loaduvm+0x87>
    else
      n = PGSIZE;
8010809c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
801080a3:	8b 55 14             	mov    0x14(%ebp),%edx
801080a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a9:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801080ac:	83 ec 0c             	sub    $0xc,%esp
801080af:	ff 75 e8             	pushl  -0x18(%ebp)
801080b2:	e8 e2 f6 ff ff       	call   80107799 <p2v>
801080b7:	83 c4 10             	add    $0x10,%esp
801080ba:	ff 75 f0             	pushl  -0x10(%ebp)
801080bd:	53                   	push   %ebx
801080be:	50                   	push   %eax
801080bf:	ff 75 10             	pushl  0x10(%ebp)
801080c2:	e8 17 9e ff ff       	call   80101ede <readi>
801080c7:	83 c4 10             	add    $0x10,%esp
801080ca:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801080cd:	74 07                	je     801080d6 <loaduvm+0xba>
      return -1;
801080cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801080d4:	eb 18                	jmp    801080ee <loaduvm+0xd2>
  for(i = 0; i < sz; i += PGSIZE){
801080d6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801080dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e0:	3b 45 18             	cmp    0x18(%ebp),%eax
801080e3:	0f 82 5f ff ff ff    	jb     80108048 <loaduvm+0x2c>
  }
  return 0;
801080e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801080ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801080f1:	c9                   	leave  
801080f2:	c3                   	ret    

801080f3 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801080f3:	55                   	push   %ebp
801080f4:	89 e5                	mov    %esp,%ebp
801080f6:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801080f9:	8b 45 10             	mov    0x10(%ebp),%eax
801080fc:	85 c0                	test   %eax,%eax
801080fe:	79 0a                	jns    8010810a <allocuvm+0x17>
    return 0;
80108100:	b8 00 00 00 00       	mov    $0x0,%eax
80108105:	e9 b0 00 00 00       	jmp    801081ba <allocuvm+0xc7>
  if(newsz < oldsz)
8010810a:	8b 45 10             	mov    0x10(%ebp),%eax
8010810d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108110:	73 08                	jae    8010811a <allocuvm+0x27>
    return oldsz;
80108112:	8b 45 0c             	mov    0xc(%ebp),%eax
80108115:	e9 a0 00 00 00       	jmp    801081ba <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
8010811a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010811d:	05 ff 0f 00 00       	add    $0xfff,%eax
80108122:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108127:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010812a:	eb 7f                	jmp    801081ab <allocuvm+0xb8>
    mem = kalloc();
8010812c:	e8 39 ab ff ff       	call   80102c6a <kalloc>
80108131:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108134:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108138:	75 2b                	jne    80108165 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
8010813a:	83 ec 0c             	sub    $0xc,%esp
8010813d:	68 21 8c 10 80       	push   $0x80108c21
80108142:	e8 7d 82 ff ff       	call   801003c4 <cprintf>
80108147:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
8010814a:	83 ec 04             	sub    $0x4,%esp
8010814d:	ff 75 0c             	pushl  0xc(%ebp)
80108150:	ff 75 10             	pushl  0x10(%ebp)
80108153:	ff 75 08             	pushl  0x8(%ebp)
80108156:	e8 61 00 00 00       	call   801081bc <deallocuvm>
8010815b:	83 c4 10             	add    $0x10,%esp
      return 0;
8010815e:	b8 00 00 00 00       	mov    $0x0,%eax
80108163:	eb 55                	jmp    801081ba <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80108165:	83 ec 04             	sub    $0x4,%esp
80108168:	68 00 10 00 00       	push   $0x1000
8010816d:	6a 00                	push   $0x0
8010816f:	ff 75 f0             	pushl  -0x10(%ebp)
80108172:	e8 30 d1 ff ff       	call   801052a7 <memset>
80108177:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010817a:	83 ec 0c             	sub    $0xc,%esp
8010817d:	ff 75 f0             	pushl  -0x10(%ebp)
80108180:	e8 07 f6 ff ff       	call   8010778c <v2p>
80108185:	83 c4 10             	add    $0x10,%esp
80108188:	89 c2                	mov    %eax,%edx
8010818a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010818d:	83 ec 0c             	sub    $0xc,%esp
80108190:	6a 06                	push   $0x6
80108192:	52                   	push   %edx
80108193:	68 00 10 00 00       	push   $0x1000
80108198:	50                   	push   %eax
80108199:	ff 75 08             	pushl  0x8(%ebp)
8010819c:	e8 1a fb ff ff       	call   80107cbb <mappages>
801081a1:	83 c4 20             	add    $0x20,%esp
  for(; a < newsz; a += PGSIZE){
801081a4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801081ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ae:	3b 45 10             	cmp    0x10(%ebp),%eax
801081b1:	0f 82 75 ff ff ff    	jb     8010812c <allocuvm+0x39>
  }
  return newsz;
801081b7:	8b 45 10             	mov    0x10(%ebp),%eax
}
801081ba:	c9                   	leave  
801081bb:	c3                   	ret    

801081bc <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801081bc:	55                   	push   %ebp
801081bd:	89 e5                	mov    %esp,%ebp
801081bf:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801081c2:	8b 45 10             	mov    0x10(%ebp),%eax
801081c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
801081c8:	72 08                	jb     801081d2 <deallocuvm+0x16>
    return oldsz;
801081ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801081cd:	e9 a5 00 00 00       	jmp    80108277 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
801081d2:	8b 45 10             	mov    0x10(%ebp),%eax
801081d5:	05 ff 0f 00 00       	add    $0xfff,%eax
801081da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801081e2:	e9 81 00 00 00       	jmp    80108268 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
801081e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ea:	83 ec 04             	sub    $0x4,%esp
801081ed:	6a 00                	push   $0x0
801081ef:	50                   	push   %eax
801081f0:	ff 75 08             	pushl  0x8(%ebp)
801081f3:	e8 23 fa ff ff       	call   80107c1b <walkpgdir>
801081f8:	83 c4 10             	add    $0x10,%esp
801081fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801081fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108202:	75 09                	jne    8010820d <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80108204:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
8010820b:	eb 54                	jmp    80108261 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
8010820d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108210:	8b 00                	mov    (%eax),%eax
80108212:	83 e0 01             	and    $0x1,%eax
80108215:	85 c0                	test   %eax,%eax
80108217:	74 48                	je     80108261 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80108219:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010821c:	8b 00                	mov    (%eax),%eax
8010821e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108223:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108226:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010822a:	75 0d                	jne    80108239 <deallocuvm+0x7d>
        panic("kfree");
8010822c:	83 ec 0c             	sub    $0xc,%esp
8010822f:	68 39 8c 10 80       	push   $0x80108c39
80108234:	e8 2e 83 ff ff       	call   80100567 <panic>
      char *v = p2v(pa);
80108239:	83 ec 0c             	sub    $0xc,%esp
8010823c:	ff 75 ec             	pushl  -0x14(%ebp)
8010823f:	e8 55 f5 ff ff       	call   80107799 <p2v>
80108244:	83 c4 10             	add    $0x10,%esp
80108247:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
8010824a:	83 ec 0c             	sub    $0xc,%esp
8010824d:	ff 75 e8             	pushl  -0x18(%ebp)
80108250:	e8 78 a9 ff ff       	call   80102bcd <kfree>
80108255:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108258:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010825b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80108261:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108268:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010826b:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010826e:	0f 82 73 ff ff ff    	jb     801081e7 <deallocuvm+0x2b>
    }
  }
  return newsz;
80108274:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108277:	c9                   	leave  
80108278:	c3                   	ret    

80108279 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108279:	55                   	push   %ebp
8010827a:	89 e5                	mov    %esp,%ebp
8010827c:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
8010827f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108283:	75 0d                	jne    80108292 <freevm+0x19>
    panic("freevm: no pgdir");
80108285:	83 ec 0c             	sub    $0xc,%esp
80108288:	68 3f 8c 10 80       	push   $0x80108c3f
8010828d:	e8 d5 82 ff ff       	call   80100567 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108292:	83 ec 04             	sub    $0x4,%esp
80108295:	6a 00                	push   $0x0
80108297:	68 00 00 00 80       	push   $0x80000000
8010829c:	ff 75 08             	pushl  0x8(%ebp)
8010829f:	e8 18 ff ff ff       	call   801081bc <deallocuvm>
801082a4:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801082a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801082ae:	eb 4f                	jmp    801082ff <freevm+0x86>
    if(pgdir[i] & PTE_P){
801082b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801082ba:	8b 45 08             	mov    0x8(%ebp),%eax
801082bd:	01 d0                	add    %edx,%eax
801082bf:	8b 00                	mov    (%eax),%eax
801082c1:	83 e0 01             	and    $0x1,%eax
801082c4:	85 c0                	test   %eax,%eax
801082c6:	74 33                	je     801082fb <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801082c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801082d2:	8b 45 08             	mov    0x8(%ebp),%eax
801082d5:	01 d0                	add    %edx,%eax
801082d7:	8b 00                	mov    (%eax),%eax
801082d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801082de:	83 ec 0c             	sub    $0xc,%esp
801082e1:	50                   	push   %eax
801082e2:	e8 b2 f4 ff ff       	call   80107799 <p2v>
801082e7:	83 c4 10             	add    $0x10,%esp
801082ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801082ed:	83 ec 0c             	sub    $0xc,%esp
801082f0:	ff 75 f0             	pushl  -0x10(%ebp)
801082f3:	e8 d5 a8 ff ff       	call   80102bcd <kfree>
801082f8:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801082fb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801082ff:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108306:	76 a8                	jbe    801082b0 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80108308:	83 ec 0c             	sub    $0xc,%esp
8010830b:	ff 75 08             	pushl  0x8(%ebp)
8010830e:	e8 ba a8 ff ff       	call   80102bcd <kfree>
80108313:	83 c4 10             	add    $0x10,%esp
}
80108316:	90                   	nop
80108317:	c9                   	leave  
80108318:	c3                   	ret    

80108319 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108319:	55                   	push   %ebp
8010831a:	89 e5                	mov    %esp,%ebp
8010831c:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010831f:	83 ec 04             	sub    $0x4,%esp
80108322:	6a 00                	push   $0x0
80108324:	ff 75 0c             	pushl  0xc(%ebp)
80108327:	ff 75 08             	pushl  0x8(%ebp)
8010832a:	e8 ec f8 ff ff       	call   80107c1b <walkpgdir>
8010832f:	83 c4 10             	add    $0x10,%esp
80108332:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108335:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108339:	75 0d                	jne    80108348 <clearpteu+0x2f>
    panic("clearpteu");
8010833b:	83 ec 0c             	sub    $0xc,%esp
8010833e:	68 50 8c 10 80       	push   $0x80108c50
80108343:	e8 1f 82 ff ff       	call   80100567 <panic>
  *pte &= ~PTE_U;
80108348:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010834b:	8b 00                	mov    (%eax),%eax
8010834d:	83 e0 fb             	and    $0xfffffffb,%eax
80108350:	89 c2                	mov    %eax,%edx
80108352:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108355:	89 10                	mov    %edx,(%eax)
}
80108357:	90                   	nop
80108358:	c9                   	leave  
80108359:	c3                   	ret    

8010835a <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010835a:	55                   	push   %ebp
8010835b:	89 e5                	mov    %esp,%ebp
8010835d:	53                   	push   %ebx
8010835e:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108361:	e8 e5 f9 ff ff       	call   80107d4b <setupkvm>
80108366:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108369:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010836d:	75 0a                	jne    80108379 <copyuvm+0x1f>
    return 0;
8010836f:	b8 00 00 00 00       	mov    $0x0,%eax
80108374:	e9 f8 00 00 00       	jmp    80108471 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80108379:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108380:	e9 c4 00 00 00       	jmp    80108449 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108385:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108388:	83 ec 04             	sub    $0x4,%esp
8010838b:	6a 00                	push   $0x0
8010838d:	50                   	push   %eax
8010838e:	ff 75 08             	pushl  0x8(%ebp)
80108391:	e8 85 f8 ff ff       	call   80107c1b <walkpgdir>
80108396:	83 c4 10             	add    $0x10,%esp
80108399:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010839c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801083a0:	75 0d                	jne    801083af <copyuvm+0x55>
      panic("copyuvm: pte should exist");
801083a2:	83 ec 0c             	sub    $0xc,%esp
801083a5:	68 5a 8c 10 80       	push   $0x80108c5a
801083aa:	e8 b8 81 ff ff       	call   80100567 <panic>
    if(!(*pte & PTE_P))
801083af:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083b2:	8b 00                	mov    (%eax),%eax
801083b4:	83 e0 01             	and    $0x1,%eax
801083b7:	85 c0                	test   %eax,%eax
801083b9:	75 0d                	jne    801083c8 <copyuvm+0x6e>
      panic("copyuvm: page not present");
801083bb:	83 ec 0c             	sub    $0xc,%esp
801083be:	68 74 8c 10 80       	push   $0x80108c74
801083c3:	e8 9f 81 ff ff       	call   80100567 <panic>
    pa = PTE_ADDR(*pte);
801083c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083cb:	8b 00                	mov    (%eax),%eax
801083cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801083d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083d8:	8b 00                	mov    (%eax),%eax
801083da:	25 ff 0f 00 00       	and    $0xfff,%eax
801083df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801083e2:	e8 83 a8 ff ff       	call   80102c6a <kalloc>
801083e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
801083ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801083ee:	74 6a                	je     8010845a <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
801083f0:	83 ec 0c             	sub    $0xc,%esp
801083f3:	ff 75 e8             	pushl  -0x18(%ebp)
801083f6:	e8 9e f3 ff ff       	call   80107799 <p2v>
801083fb:	83 c4 10             	add    $0x10,%esp
801083fe:	83 ec 04             	sub    $0x4,%esp
80108401:	68 00 10 00 00       	push   $0x1000
80108406:	50                   	push   %eax
80108407:	ff 75 e0             	pushl  -0x20(%ebp)
8010840a:	e8 57 cf ff ff       	call   80105366 <memmove>
8010840f:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108412:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108415:	83 ec 0c             	sub    $0xc,%esp
80108418:	ff 75 e0             	pushl  -0x20(%ebp)
8010841b:	e8 6c f3 ff ff       	call   8010778c <v2p>
80108420:	83 c4 10             	add    $0x10,%esp
80108423:	89 c2                	mov    %eax,%edx
80108425:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108428:	83 ec 0c             	sub    $0xc,%esp
8010842b:	53                   	push   %ebx
8010842c:	52                   	push   %edx
8010842d:	68 00 10 00 00       	push   $0x1000
80108432:	50                   	push   %eax
80108433:	ff 75 f0             	pushl  -0x10(%ebp)
80108436:	e8 80 f8 ff ff       	call   80107cbb <mappages>
8010843b:	83 c4 20             	add    $0x20,%esp
8010843e:	85 c0                	test   %eax,%eax
80108440:	78 1b                	js     8010845d <copyuvm+0x103>
  for(i = 0; i < sz; i += PGSIZE){
80108442:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108449:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010844c:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010844f:	0f 82 30 ff ff ff    	jb     80108385 <copyuvm+0x2b>
      goto bad;
  }
  return d;
80108455:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108458:	eb 17                	jmp    80108471 <copyuvm+0x117>
      goto bad;
8010845a:	90                   	nop
8010845b:	eb 01                	jmp    8010845e <copyuvm+0x104>
      goto bad;
8010845d:	90                   	nop

bad:
  freevm(d);
8010845e:	83 ec 0c             	sub    $0xc,%esp
80108461:	ff 75 f0             	pushl  -0x10(%ebp)
80108464:	e8 10 fe ff ff       	call   80108279 <freevm>
80108469:	83 c4 10             	add    $0x10,%esp
  return 0;
8010846c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108471:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108474:	c9                   	leave  
80108475:	c3                   	ret    

80108476 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108476:	55                   	push   %ebp
80108477:	89 e5                	mov    %esp,%ebp
80108479:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010847c:	83 ec 04             	sub    $0x4,%esp
8010847f:	6a 00                	push   $0x0
80108481:	ff 75 0c             	pushl  0xc(%ebp)
80108484:	ff 75 08             	pushl  0x8(%ebp)
80108487:	e8 8f f7 ff ff       	call   80107c1b <walkpgdir>
8010848c:	83 c4 10             	add    $0x10,%esp
8010848f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108492:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108495:	8b 00                	mov    (%eax),%eax
80108497:	83 e0 01             	and    $0x1,%eax
8010849a:	85 c0                	test   %eax,%eax
8010849c:	75 07                	jne    801084a5 <uva2ka+0x2f>
    return 0;
8010849e:	b8 00 00 00 00       	mov    $0x0,%eax
801084a3:	eb 2a                	jmp    801084cf <uva2ka+0x59>
  if((*pte & PTE_U) == 0)
801084a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084a8:	8b 00                	mov    (%eax),%eax
801084aa:	83 e0 04             	and    $0x4,%eax
801084ad:	85 c0                	test   %eax,%eax
801084af:	75 07                	jne    801084b8 <uva2ka+0x42>
    return 0;
801084b1:	b8 00 00 00 00       	mov    $0x0,%eax
801084b6:	eb 17                	jmp    801084cf <uva2ka+0x59>
  return (char*)p2v(PTE_ADDR(*pte));
801084b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084bb:	8b 00                	mov    (%eax),%eax
801084bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084c2:	83 ec 0c             	sub    $0xc,%esp
801084c5:	50                   	push   %eax
801084c6:	e8 ce f2 ff ff       	call   80107799 <p2v>
801084cb:	83 c4 10             	add    $0x10,%esp
801084ce:	90                   	nop
}
801084cf:	c9                   	leave  
801084d0:	c3                   	ret    

801084d1 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801084d1:	55                   	push   %ebp
801084d2:	89 e5                	mov    %esp,%ebp
801084d4:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801084d7:	8b 45 10             	mov    0x10(%ebp),%eax
801084da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801084dd:	eb 7f                	jmp    8010855e <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
801084df:	8b 45 0c             	mov    0xc(%ebp),%eax
801084e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801084ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084ed:	83 ec 08             	sub    $0x8,%esp
801084f0:	50                   	push   %eax
801084f1:	ff 75 08             	pushl  0x8(%ebp)
801084f4:	e8 7d ff ff ff       	call   80108476 <uva2ka>
801084f9:	83 c4 10             	add    $0x10,%esp
801084fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
801084ff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108503:	75 07                	jne    8010850c <copyout+0x3b>
      return -1;
80108505:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010850a:	eb 61                	jmp    8010856d <copyout+0x9c>
    n = PGSIZE - (va - va0);
8010850c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010850f:	2b 45 0c             	sub    0xc(%ebp),%eax
80108512:	05 00 10 00 00       	add    $0x1000,%eax
80108517:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
8010851a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010851d:	3b 45 14             	cmp    0x14(%ebp),%eax
80108520:	76 06                	jbe    80108528 <copyout+0x57>
      n = len;
80108522:	8b 45 14             	mov    0x14(%ebp),%eax
80108525:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108528:	8b 45 0c             	mov    0xc(%ebp),%eax
8010852b:	2b 45 ec             	sub    -0x14(%ebp),%eax
8010852e:	89 c2                	mov    %eax,%edx
80108530:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108533:	01 d0                	add    %edx,%eax
80108535:	83 ec 04             	sub    $0x4,%esp
80108538:	ff 75 f0             	pushl  -0x10(%ebp)
8010853b:	ff 75 f4             	pushl  -0xc(%ebp)
8010853e:	50                   	push   %eax
8010853f:	e8 22 ce ff ff       	call   80105366 <memmove>
80108544:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108547:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010854a:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010854d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108550:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108553:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108556:	05 00 10 00 00       	add    $0x1000,%eax
8010855b:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
8010855e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108562:	0f 85 77 ff ff ff    	jne    801084df <copyout+0xe>
  }
  return 0;
80108568:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010856d:	c9                   	leave  
8010856e:	c3                   	ret    
