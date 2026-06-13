import {
  Controller,
  Get,
  Delete,
  Put,
  Body,
  Param,
  Req,
  UseGuards,
  HttpStatus,
  HttpCode,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { BasicAuthGuard } from '../auth';
import { Order, OrderService } from '../order';
import { AppRequest, getUserIdFromRequest } from '../shared';
import { calculateCartTotal } from './models-rules';
import { CartService } from './services';
import { CartItem } from './models';
import { CreateOrderDto, OrderStatus, PutCartPayload } from 'src/order/type';

@Controller('api/profile/cart')
export class CartController {
  constructor(
    private cartService: CartService,
    private orderService: OrderService,
  ) { }

  // @UseGuards(JwtAuthGuard)
  @UseGuards(BasicAuthGuard)
  @Get()
  async findUserCart(@Req() req: AppRequest): Promise<CartItem[]> {
    const cart = await this.cartService.findOrCreateByUserId(
      getUserIdFromRequest(req),
    );

    return cart.items;
  }

  // @UseGuards(JwtAuthGuard)
  @UseGuards(BasicAuthGuard)
  @Put()
  async updateUserCart(
    @Req() req: AppRequest,
    @Body() body: PutCartPayload,
  ): Promise<CartItem[]> {
    const cart = await this.cartService.updateByUserId(
      getUserIdFromRequest(req),
      body,
    );

    if (!cart) {
      throw new BadRequestException('Cart not found');
    }

    return cart.items;
  }

  // @UseGuards(JwtAuthGuard)
  @UseGuards(BasicAuthGuard)
  @Delete()
  @HttpCode(HttpStatus.OK)
  async clearUserCart(@Req() req: AppRequest) {
    await this.cartService.removeByUserId(getUserIdFromRequest(req));
  }

  // @UseGuards(JwtAuthGuard)
  @UseGuards(BasicAuthGuard)
  @Put('order')
  async checkout(@Req() req: AppRequest, @Body() body: CreateOrderDto) {
    const userId = getUserIdFromRequest(req);
    const cart = await this.cartService.findByUserId(userId);

    if (!cart || !cart.items.length) {
      throw new BadRequestException('Cart is empty');
    }

    const { id: cartId, items } = cart;
    const total = calculateCartTotal(items);
    const order = await this.orderService.create({
      userId,
      cartId,
      items: items.map(({ product, count }) => ({
        productId: product.id,
        count,
      })),
      address: body.address,
      total,
    });

    return {
      order,
    };
  }

  @UseGuards(BasicAuthGuard)
  @Get('order')
  async getOrder(@Req() req: AppRequest): Promise<Order[]> {
    const userId = getUserIdFromRequest(req);
    return await this.orderService.getAll(userId);
  }

  @UseGuards(BasicAuthGuard)
  @Get('order/:id')
  async getOrderById(
    @Req() req: AppRequest,
    @Param('id') orderId: string,
  ): Promise<Order> {
    const userId = getUserIdFromRequest(req);
    const order = await this.orderService.findById(orderId, userId);
    if (!order) {
      throw new NotFoundException('Order not found');
    }
    return order;
  }

  @UseGuards(BasicAuthGuard)
  @Delete('order/:id')
  async deleteOrderById(
    @Req() req: AppRequest,
    @Param('id') orderId: string,
  ): Promise<void> {
    const userId = getUserIdFromRequest(req);
    const order = await this.orderService.findById(orderId, userId);
    if (!order) {
      throw new NotFoundException('Order not found');
    }
    await this.orderService.deleteById(orderId);
  }

  @UseGuards(BasicAuthGuard)
  @Put('order/:id')
  async updateOrderStatusById(
    @Req() req: AppRequest,
    @Param('id') orderId: string,
    @Body() body: { status: string; comment?: string },
  ): Promise<void> {
    const validStatuses = Object.values(OrderStatus) as string[];
    if (!body.status || !validStatuses.includes(body.status)) {
      throw new BadRequestException(`Invalid status. Allowed: ${validStatuses.join(', ')}`);
    }
    const userId = getUserIdFromRequest(req);
    const order = await this.orderService.findById(orderId, userId);
    if (!order) {
      throw new NotFoundException('Order not found');
    }
    return await this.orderService.updateStatusById(orderId, body.status as OrderStatus, body.comment);
  }
}
