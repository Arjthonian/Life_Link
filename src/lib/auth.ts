import { supabase } from './supabase';

export async function signUp(
  email: string,
  password: string,
  userData: {
    name: string;
    phone: string;
    blood_group: string;
    location: string;
  }
) {
  const { data: authData, error: authError } = await supabase.auth.signUp({
    email,
    password,
  });

  if (authError) throw authError;
  if (!authData.user) throw new Error('User creation failed');

  const { error: userError } = await supabase.from('users').insert({
    id: authData.user.id,
    name: userData.name,
    email: email,
    phone: userData.phone,
    blood_group: userData.blood_group,
    location: userData.location,
  });

  if (userError) throw userError;

  const { error: donorError } = await supabase.from('donors').insert({
    user_id: authData.user.id,
    availability: true,
  });

  if (donorError) throw donorError;

  return authData;
}

export async function signIn(email: string, password: string) {
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  });

  if (error) throw error;
  return data;
}

export async function signOut() {
  const { error } = await supabase.auth.signOut();
  if (error) throw error;
}

export async function getCurrentUser() {
  const { data: { user } } = await supabase.auth.getUser();
  return user;
}

export async function getUserProfile(userId: string) {
  const { data, error } = await supabase
    .from('users')
    .select('*')
    .eq('id', userId)
    .maybeSingle();

  if (error) throw error;
  return data;
}
