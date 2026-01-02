import { z } from 'zod';

export const PasswordSchema = z
    .string({ error: 'Password is required' })
    .min(8, 'Password must be at least 8 characters long')
    .max(32, 'Password must be at most 32 characters long')
    .regex(/[A-Z]/, 'Password must contain at least one uppercase letter')
    .regex(/[a-z]/, 'Password must contain at least one lowercase letter')
    .regex(/[0-9]/, 'Password must contain at least one number')
    .regex(/[\W_]/, 'Password must contain at least one special character');

export const EmailSchema = z
    .string({ error: 'Email is required' })
    .regex(/^[^\s@]+@[^\s@]+\.[^\s@]+$/, 'Invalid email format');