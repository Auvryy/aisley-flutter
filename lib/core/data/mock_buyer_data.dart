// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import '../models/address.dart';
import '../models/buyer_profile.dart';
import '../models/chat.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/voucher.dart';

// Test Buyer Profiles
final BuyerProfile MOCK_APPROVED_BUYER = BuyerProfile(
  id: 'usr_buyer_001',
  email: 'sophia.rustia@luxmail.ph',
  firstName: 'Sophia',
  lastName: 'Rustia',
  middleInitial: 'A',
  sex: 'Female',
  contactNo: '+63 917 882 9901',
  birthday: '1993-04-12',
  age: 33,
  address: const PhilippineAddress(
    province: 'Metro Manila (NCR)',
    city: 'Makati City',
    barangay: 'Forbes Park',
    street: '28 Narra Avenue',
    houseNumber: 'Villa 14',
    postalCode: '1200',
  ),
  kycIdType: 'Philippine Passport',
  kycIdFileName: 'passport_sophia_rustia.pdf',
  kycIdPreviewUrl: 'https://images.unsplash.com/photo-1544717305-2782549b5136?w=300&auto=format&fit=crop&q=80',
  submittedAt: '2026-08-15T09:00:00Z',
  status: BuyerStatus.approved,
  isVip: true,
  avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80',
);

final BuyerProfile MOCK_PENDING_BUYER = BuyerProfile(
  id: 'usr_buyer_002',
  email: 'mateo.alcantara@lifestyle.ph',
  firstName: 'Mateo',
  lastName: 'Alcantara',
  middleInitial: 'J',
  sex: 'Male',
  contactNo: '+63 918 554 1122',
  birthday: '1998-10-25',
  age: 27,
  address: const PhilippineAddress(
    province: 'Metro Manila (NCR)',
    city: 'Taguig City (BGC)',
    barangay: 'Fort Bonifacio',
    street: '5th Avenue, One Bonifacio High',
    houseNumber: 'Unit 22A',
    postalCode: '1630',
  ),
  kycIdType: 'PhilSys National ID',
  kycIdFileName: 'philsys_mateo_alcantara.jpg',
  kycIdPreviewUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&auto=format&fit=crop&q=80',
  submittedAt: '2026-08-21T11:20:00Z',
  status: BuyerStatus.pending,
  isVip: false,
  avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80',
);

// Curated Luxury Products
final List<Product> MOCK_PRODUCTS = [
  const Product(
    id: 'prod-001',
    title: 'Signature Noir Structured Silk Blazer',
    boutiqueName: 'Maison Dela Tour',
    sku: 'MDT-BLZ-001',
    category: 'Apparel & Haute Couture',
    description:
        'Sculpted single-breasted blazer woven from heavyweight mulberry raw silk with hand-carved horn button closures and silk habotai interior lining.',
    basePrice: 14850.00,
    compareAtPrice: 16500.00,
    stock: 14,
    imageUrl:
        'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=600&auto=format&fit=crop&q=80',
    images: [
      'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=600&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=600&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=600&auto=format&fit=crop&q=80',
    ],
    variants: [
      ProductVariant(id: 'v-101', name: 'Size S • Noir Black', sku: 'MDT-BLZ-001-S-NR', price: 14850.00, stock: 4),
      ProductVariant(id: 'v-102', name: 'Size M • Noir Black', sku: 'MDT-BLZ-001-M-NR', price: 14850.00, stock: 7),
      ProductVariant(id: 'v-103', name: 'Size L • Noir Black', sku: 'MDT-BLZ-001-L-NR', price: 14850.00, stock: 3),
    ],
    sizes: ['S', 'M', 'L'],
    colors: ['Noir Black', 'Ivory Cream'],
    rating: 4.9,
    reviewCount: 18,
    isFeatured: true,
    reviews: [
      ProductReview(
        id: 'rev-101',
        authorName: 'Camilla Valderrama',
        authorAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&auto=format&fit=crop&q=80',
        rating: 5.0,
        date: '2 days ago',
        variantPurchased: 'Size M • Noir Black',
        comment: 'The drape and tailoring are exquisite! The raw silk holds a subtle sheen that looks effortless yet commanding. White-glove delivery in Manila was seamless.',
      ),
      ProductReview(
        id: 'rev-102',
        authorName: 'Rafael Santillan',
        authorAvatar: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100&auto=format&fit=crop&q=80',
        rating: 5.0,
        date: '1 week ago',
        variantPurchased: 'Size L • Noir Black',
        comment: 'Superior quality horn buttons and luxury lining. Maison Dela Tour truly preserves bespoke French-Philippine heritage craftsmanship.',
      ),
      ProductReview(
        id: 'rev-103',
        authorName: 'Bianca Teodoro',
        authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&auto=format&fit=crop&q=80',
        rating: 4.8,
        date: '2 weeks ago',
        variantPurchased: 'Size S • Ivory Cream',
        comment: 'Fits true to size with a gentle relaxed shoulder pad structure. Beautifully packaged with cedar garment bag.',
      ),
    ],
  ),
  const Product(
    id: 'prod-002',
    title: 'Draped Asymmetrical Silk Slip Dress',
    boutiqueName: 'Maison Dela Tour',
    sku: 'MDT-DRS-002',
    category: 'Apparel & Haute Couture',
    description:
        'Bias-cut 22-momme pure silk charmeuse dress featuring delicate spaghetti straps and a cascading architectural drape hemline.',
    basePrice: 9200.00,
    compareAtPrice: 10500.00,
    stock: 8,
    imageUrl:
        'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=600&auto=format&fit=crop&q=80',
    images: [
      'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=600&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=600&auto=format&fit=crop&q=80',
    ],
    variants: [
      ProductVariant(id: 'v-201', name: 'Size XS • Mulberry Rose', sku: 'MDT-DRS-002-XS-RS', price: 9200.00, stock: 2),
      ProductVariant(id: 'v-202', name: 'Size S • Mulberry Rose', sku: 'MDT-DRS-002-S-RS', price: 9200.00, stock: 3),
      ProductVariant(id: 'v-203', name: 'Size M • Mulberry Rose', sku: 'MDT-DRS-002-M-RS', price: 9200.00, stock: 3),
    ],
    sizes: ['XS', 'S', 'M'],
    colors: ['Mulberry Rose', 'Champagne Pearl'],
    rating: 5.0,
    reviewCount: 9,
    isFeatured: true,
    reviews: [
      ProductReview(
        id: 'rev-201',
        authorName: 'Isabella Zobel',
        authorAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format&fit=crop&q=80',
        rating: 5.0,
        date: '3 days ago',
        variantPurchased: 'Size S • Mulberry Rose',
        comment: 'Pure elegance. The bias cut conforms gracefully to movements. Wore it to an evening gala and received endless compliments.',
      ),
    ],
  ),
  const Product(
    id: 'prod-003',
    title: 'Hand-Hammered Sterling Ribbon Cuff',
    boutiqueName: 'Luzon Goldsmiths',
    sku: 'LZN-JWL-003',
    category: 'Fine Jewelry & Metals',
    description:
        'Solid 925 sterling silver statement cuff sculpted with undulating organic folds and a hand-burnished satin luster.',
    basePrice: 6800.00,
    compareAtPrice: 7500.00,
    stock: 22,
    imageUrl:
        'https://images.unsplash.com/photo-1611591475837-77565e3cf758?w=600&auto=format&fit=crop&q=80',
    images: [
      'https://images.unsplash.com/photo-1611591475837-77565e3cf758?w=600&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=600&auto=format&fit=crop&q=80',
    ],
    variants: [
      ProductVariant(id: 'v-301', name: 'Standard • 925 Sterling Silver', sku: 'LZN-JWL-003-SLV', price: 6800.00, stock: 14),
      ProductVariant(id: 'v-302', name: 'Standard • 18K Gold Vermeil', sku: 'LZN-JWL-003-GLD', price: 8200.00, stock: 8),
    ],
    sizes: ['Adjustable Cuff'],
    colors: ['925 Sterling Silver', '18K Gold Vermeil'],
    rating: 4.8,
    reviewCount: 24,
    isFeatured: true,
    reviews: [
      ProductReview(
        id: 'rev-301',
        authorName: 'Tristan Roxas',
        authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&auto=format&fit=crop&q=80',
        rating: 5.0,
        date: '5 days ago',
        variantPurchased: '18K Gold Vermeil',
        comment: 'Heft and hand-hammered finish are phenomenal. Feels like museum piece jewelry.',
      ),
    ],
  ),
  const Product(
    id: 'prod-004',
    title: 'Monolith Minimalist Saddle Bag',
    boutiqueName: 'Marikina Atelier',
    sku: 'MRK-LTH-004',
    category: 'Artisanal Leather',
    description:
        'Full-grain vegetable-tanned Tuscan calfskin structured cross-body bag with magnetic closure and edge-painted hand finish.',
    basePrice: 18500.00,
    compareAtPrice: 21000.00,
    stock: 5,
    imageUrl:
        'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=600&auto=format&fit=crop&q=80',
    images: [
      'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=600&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=600&auto=format&fit=crop&q=80',
    ],
    variants: [
      ProductVariant(id: 'v-401', name: 'One Size • Saddle Tan', sku: 'MRK-LTH-004-TAN', price: 18500.00, stock: 3),
      ProductVariant(id: 'v-402', name: 'One Size • Obsidian Black', sku: 'MRK-LTH-004-NR', price: 18500.00, stock: 2),
    ],
    sizes: ['One Size (24 x 18 cm)'],
    colors: ['Saddle Tan', 'Obsidian Black'],
    rating: 4.9,
    reviewCount: 14,
    isFeatured: true,
    reviews: [
      ProductReview(
        id: 'rev-401',
        authorName: 'Marites Ayala',
        authorAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&auto=format&fit=crop&q=80',
        rating: 5.0,
        date: '4 days ago',
        variantPurchased: 'One Size • Saddle Tan',
        comment: 'The scent of genuine vegetable-tanned leather is wonderful. Hand-stitching from Marikina masters is unmatched.',
      ),
    ],
  ),
  const Product(
    id: 'prod-005',
    title: 'N° 07 Santal & Wild Jasmine Extrait',
    boutiqueName: 'Aura Botanica',
    sku: 'ARA-FRG-005',
    category: 'Botanical Fragrances',
    description:
        'High-concentration parfum extrait formulated with Philippine native Sampaguita enfleurage, smoky Mysore sandalwood, and warm amber resin.',
    basePrice: 5400.00,
    compareAtPrice: 6000.00,
    stock: 35,
    imageUrl:
        'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?w=600&auto=format&fit=crop&q=80',
    images: [
      'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?w=600&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1547887537-6158d64c35b3?w=600&auto=format&fit=crop&q=80',
    ],
    variants: [
      ProductVariant(id: 'v-501', name: '50ml Luxury Flacon', sku: 'ARA-FRG-005-50ML', price: 5400.00, stock: 35),
    ],
    sizes: ['50ml Extrait'],
    colors: ['Amber Crystal Glass'],
    rating: 5.0,
    reviewCount: 31,
    isFeatured: false,
    reviews: [
      ProductReview(
        id: 'rev-501',
        authorName: 'Enrique Lopez',
        authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&auto=format&fit=crop&q=80',
        rating: 5.0,
        date: '1 week ago',
        variantPurchased: '50ml Luxury Flacon',
        comment: 'Lasts over 14 hours on skin. The natural Sampaguita note is authentic and intoxicating.',
      ),
    ],
  ),
  const Product(
    id: 'prod-006',
    title: 'Wabi-Sabi Raw Terracotta Amphora',
    boutiqueName: 'Ilocos Clay Guild',
    sku: 'ILC-CRM-006',
    category: 'Handcrafted Ceramics',
    description:
        'Hand-thrown stoneware vessel finished with unglazed iron-rich volcanic clay slip, wood kiln fired for 36 hours.',
    basePrice: 4200.00,
    compareAtPrice: 4800.00,
    stock: 6,
    imageUrl:
        'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=600&auto=format&fit=crop&q=80',
    images: [
      'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=600&auto=format&fit=crop&q=80',
    ],
    variants: [
      ProductVariant(id: 'v-601', name: 'Medium Vessel (32cm)', sku: 'ILC-CRM-006-MED', price: 4200.00, stock: 6),
    ],
    sizes: ['32cm Height'],
    colors: ['Raw Terracotta'],
    rating: 4.7,
    reviewCount: 8,
    isFeatured: false,
    reviews: [
      ProductReview(
        id: 'rev-601',
        authorName: 'Dominique Tan',
        authorAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format&fit=crop&q=80',
        rating: 5.0,
        date: '2 weeks ago',
        variantPurchased: 'Medium Vessel (32cm)',
        comment: 'Incredible texture and weight. Anchors our dining table aesthetic perfectly.',
      ),
    ],
  ),
];

// Available Vouchers
final List<Voucher> MOCK_VOUCHERS = [
  const Voucher(
    id: 'vouch-101',
    code: 'AISLEY15',
    description: '15% OFF for orders over ₱8,000 (Max ₱2,500)',
    discountType: VoucherDiscountType.percentage,
    discountValue: 15,
    minSpend: 8000,
    maxDiscount: 2500,
    validUntil: 'Aug 31, 2026',
  ),
  const Voucher(
    id: 'vouch-102',
    code: 'AISLEYFIRST1000',
    description: '₱1,000 OFF First Order (Min ₱10,000)',
    discountType: VoucherDiscountType.fixed,
    discountValue: 1000,
    minSpend: 10000,
    validUntil: 'Sep 15, 2026',
  ),
  const Voucher(
    id: 'vouch-103',
    code: 'VIPRUNWAY25',
    description: '25% OFF VIP Exclusive (Min ₱20,000)',
    discountType: VoucherDiscountType.percentage,
    discountValue: 25,
    minSpend: 20000,
    maxDiscount: 6000,
    validUntil: 'Aug 31, 2026',
  ),
];

// Initial Buyer Orders
final List<BuyerOrder> INITIAL_BUYER_ORDERS = [
  BuyerOrder(
    id: 'ord-101',
    orderNumber: 'AIS-2026-9021',
    trackingNumber: 'AIS-EXP-8891-MNL',
    items: const [
      OrderItemData(
        productId: 'prod-001',
        productTitle: 'Signature Noir Structured Silk Blazer',
        boutiqueName: 'Maison Dela Tour',
        variantDescription: 'Size: M • Noir Black',
        unitPrice: 14850.00,
        quantity: 1,
        imageUrl: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=600&auto=format&fit=crop&q=80',
      ),
      OrderItemData(
        productId: 'prod-005',
        productTitle: 'N° 07 Santal & Wild Jasmine Extrait',
        boutiqueName: 'Aura Botanica',
        variantDescription: '50ml Luxury Flacon',
        unitPrice: 5400.00,
        quantity: 1,
        imageUrl: 'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?w=600&auto=format&fit=crop&q=80',
      ),
    ],
    subtotal: 20250.00,
    shippingFee: 250.00,
    discountAmount: 2500.00,
    voucherCode: 'AISLEY15',
    totalAmount: 18000.00,
    paymentMethod: 'GCash',
    status: OrderStatus.inTransit,
    courierName: 'Aisley White Glove Express',
    shippingAddress: const PhilippineAddress(
      province: 'Metro Manila (NCR)',
      city: 'Makati City',
      barangay: 'Forbes Park',
      street: '28 Narra Avenue',
      houseNumber: 'Villa 14',
      postalCode: '1200',
    ),
    createdAt: 'Aug 21, 2026 • 09:15 AM',
    timeline: const [
      TrackingMilestone(
        title: 'Order Placed & Payment Verified',
        description: 'Payment of ₱18,000.00 confirmed via GCash.',
        timestamp: 'Aug 21, 2026 • 09:15 AM',
        isCompleted: true,
      ),
      TrackingMilestone(
        title: 'Boutique Packed & Inspected',
        description: 'Maison Dela Tour signature luxury packaging prepared.',
        timestamp: 'Aug 21, 2026 • 11:30 AM',
        isCompleted: true,
      ),
      TrackingMilestone(
        title: 'Handed Over to Courier',
        description: 'Parcel collected by Aisley White Glove Courier.',
        timestamp: 'Aug 21, 2026 • 01:45 PM',
        isCompleted: true,
      ),
      TrackingMilestone(
        title: 'In Transit to Recipient Hub',
        description: 'En route to Makati City delivery hub.',
        timestamp: 'Aug 21, 2026 • 03:20 PM',
        isCompleted: true,
      ),
      TrackingMilestone(
        title: 'Out for Doorstep Delivery',
        description: 'White Glove driver dispatched for Forbes Park arrival.',
        timestamp: 'Estimated: Tomorrow by 11:00 AM',
        isCompleted: false,
      ),
    ],
  ),
  BuyerOrder(
    id: 'ord-102',
    orderNumber: 'AIS-2026-8812',
    trackingNumber: 'JT-PH-99210482',
    items: const [
      OrderItemData(
        productId: 'prod-004',
        productTitle: 'Monolith Minimalist Saddle Bag',
        boutiqueName: 'Marikina Atelier',
        variantDescription: 'One Size • Saddle Tan',
        unitPrice: 18500.00,
        quantity: 1,
        imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=600&auto=format&fit=crop&q=80',
      ),
    ],
    subtotal: 18500.00,
    shippingFee: 200.00,
    discountAmount: 1000.00,
    voucherCode: 'AISLEYFIRST1000',
    totalAmount: 17700.00,
    paymentMethod: 'Maya',
    status: OrderStatus.toShip,
    courierName: 'J&T Express',
    shippingAddress: const PhilippineAddress(
      province: 'Metro Manila (NCR)',
      city: 'Makati City',
      barangay: 'Forbes Park',
      street: '28 Narra Avenue',
      houseNumber: 'Villa 14',
      postalCode: '1200',
    ),
    createdAt: 'Aug 21, 2026 • 07:45 AM',
    timeline: const [
      TrackingMilestone(
        title: 'Order Placed & Paid',
        description: 'Order confirmed by buyer.',
        timestamp: 'Aug 21, 2026 • 07:45 AM',
        isCompleted: true,
      ),
      TrackingMilestone(
        title: 'Awaiting Boutique Dispatch',
        description: 'Marikina Atelier is preparing handcrafted packaging.',
        timestamp: 'In Progress',
        isCompleted: false,
      ),
    ],
  ),
  BuyerOrder(
    id: 'ord-100',
    orderNumber: 'AIS-2026-7910',
    trackingNumber: 'FLASH-PH-772910',
    items: const [
      OrderItemData(
        productId: 'prod-003',
        productTitle: 'Hand-Hammered Sterling Ribbon Cuff',
        boutiqueName: 'Luzon Goldsmiths',
        variantDescription: 'Standard • 18K Gold Vermeil',
        unitPrice: 8200.00,
        quantity: 1,
        imageUrl: 'https://images.unsplash.com/photo-1611591475837-77565e3cf758?w=600&auto=format&fit=crop&q=80',
      ),
    ],
    subtotal: 8200.00,
    shippingFee: 150.00,
    discountAmount: 0.00,
    totalAmount: 8350.00,
    paymentMethod: 'Credit Card',
    status: OrderStatus.delivered,
    courierName: 'Flash Express',
    shippingAddress: const PhilippineAddress(
      province: 'Metro Manila (NCR)',
      city: 'Makati City',
      barangay: 'Forbes Park',
      street: '28 Narra Avenue',
      houseNumber: 'Villa 14',
      postalCode: '1200',
    ),
    createdAt: 'Aug 14, 2026 • 02:10 PM',
    timeline: const [
      TrackingMilestone(
        title: 'Delivered Successfully',
        description: 'Signed and received by Sophia Rustia at Forbes Park.',
        timestamp: 'Aug 16, 2026 • 04:30 PM',
        isCompleted: true,
      ),
    ],
    review: const CustomerReview(
      rating: 5.0,
      comment: 'Exquisite jewelry finish! The gold vermeil has such a brilliant warm glow. Packed immaculately.',
      createdAt: 'Aug 17, 2026',
    ),
  ),
];

// Initial Chat Threads
final List<ChatThread> INITIAL_CHAT_THREADS = [
  ChatThread(
    id: 'chat-thread-1',
    boutiqueName: 'Maison Dela Tour Concierge',
    boutiqueAvatar: 'https://images.unsplash.com/photo-1544816155-12df9643f363?w=200&auto=format&fit=crop&q=80',
    location: 'Makati City • Haute Couture',
    lastActive: 'Just now',
    unreadCount: 1,
    messages: [
      const ChatMessage(
        id: 'msg-1',
        senderId: 'boutique-1',
        senderName: 'Claire (Maison Dela Tour)',
        isFromBuyer: false,
        text: 'Mabuhay Sophia! Thank you for inquiring about our Signature Noir Structured Silk Blazer.',
        timestamp: '10:15 AM',
      ),
      const ChatMessage(
        id: 'msg-2',
        senderId: 'usr_buyer_001',
        senderName: 'Sophia',
        isFromBuyer: true,
        text: 'Hi Claire! Does the silk blazer run true to size, or would you recommend sizing up for layering?',
        timestamp: '10:18 AM',
      ),
      const ChatMessage(
        id: 'msg-3',
        senderId: 'boutique-1',
        senderName: 'Claire (Maison Dela Tour)',
        isFromBuyer: false,
        text: 'It is tailored with a tailored European silhouette. Size M will provide that sculpted look, while Size L is ideal if you prefer relaxed shoulder drape.',
        timestamp: '10:22 AM',
        attachment: ChatProductAttachment(
          productId: 'prod-001',
          title: 'Signature Noir Structured Silk Blazer',
          price: 14850.00,
          imageUrl: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=600&auto=format&fit=crop&q=80',
        ),
      ),
    ],
  ),
  ChatThread(
    id: 'chat-thread-2',
    boutiqueName: 'Luzon Goldsmiths',
    boutiqueAvatar: 'https://images.unsplash.com/photo-1611591475837-77565e3cf758?w=200&auto=format&fit=crop&q=80',
    location: 'Manila • Fine Jewelry',
    lastActive: '2h ago',
    unreadCount: 0,
    messages: [
      const ChatMessage(
        id: 'msg-201',
        senderId: 'boutique-2',
        senderName: 'Luzon Goldsmiths',
        isFromBuyer: false,
        text: 'Hello Sophia! Your Ribbon Cuff has been polished with anti-tarnish coating prior to courier handover.',
        timestamp: 'Yesterday',
      ),
    ],
  ),
];

// Canned inquiries
const List<String> CANNED_INQUIRIES = [
  'Is this item available for same-day dispatch?',
  'Can I request complimentary luxury gift wrapping?',
  'What are the exact bust and waist measurements?',
  'Do you provide custom sizing or alterations?',
];
