CREATE TABLE public.vip_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL CHECK (char_length(name) BETWEEN 1 AND 120),
  email text NOT NULL CHECK (char_length(email) BETWEEN 3 AND 255),
  city text CHECK (char_length(city) <= 120),
  reason text CHECK (char_length(reason) <= 2000),
  created_at timestamptz NOT NULL DEFAULT now()
);
GRANT INSERT ON public.vip_requests TO anon, authenticated;
GRANT SELECT, DELETE ON public.vip_requests TO authenticated;
GRANT ALL ON public.vip_requests TO service_role;
ALTER TABLE public.vip_requests ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can submit VIP requests" ON public.vip_requests FOR INSERT TO anon, authenticated WITH CHECK (true);
CREATE POLICY "Admins read VIP requests" ON public.vip_requests FOR SELECT TO authenticated USING (public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Admins delete VIP requests" ON public.vip_requests FOR DELETE TO authenticated USING (public.has_role(auth.uid(), 'admin'));

CREATE TABLE public.newsletter_subscribers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text CHECK (char_length(name) <= 120),
  email text NOT NULL UNIQUE CHECK (char_length(email) BETWEEN 3 AND 255),
  created_at timestamptz NOT NULL DEFAULT now()
);
GRANT INSERT ON public.newsletter_subscribers TO anon, authenticated;
GRANT SELECT, DELETE ON public.newsletter_subscribers TO authenticated;
GRANT ALL ON public.newsletter_subscribers TO service_role;
ALTER TABLE public.newsletter_subscribers ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can subscribe" ON public.newsletter_subscribers FOR INSERT TO anon, authenticated WITH CHECK (true);
CREATE POLICY "Admins read subscribers" ON public.newsletter_subscribers FOR SELECT TO authenticated USING (public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Admins delete subscribers" ON public.newsletter_subscribers FOR DELETE TO authenticated USING (public.has_role(auth.uid(), 'admin'));