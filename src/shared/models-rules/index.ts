import { AppRequest } from '../models';

/**
 * @param {AppRequest} request
 * @returns {string}
 */
export function getUserIdFromRequest(request: AppRequest): string {
  if (!request.user?.id) {
    throw new Error('User id is missing from request');
  }
  return request.user.id;
}
