import { z } from 'zod';

export const LoginSchema = z.object({
    body: z.object({
        username: z.string({ error: 'Username is required' }),
        password: z.string({ error: 'Password is required' })
    }),
    params: z.object({}),
    query: z.object({})
});

export type LoginSchemaType = z.infer<typeof LoginSchema>;