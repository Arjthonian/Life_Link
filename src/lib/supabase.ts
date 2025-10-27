import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

export type User = {
  id: string;
  name: string;
  email: string;
  phone: string;
  blood_group: string;
  location: string;
  created_at: string;
};

export type Donor = {
  id: string;
  user_id: string;
  availability: boolean;
  last_donation_date: string | null;
  created_at: string;
  updated_at: string;
};

export type DonorWithUser = Donor & {
  users: User;
};
