import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.25.0";

///
/// リクエストを出したユーザーのデータを削除する Supabase Edge Function
/// -> $ supabase functions deploy delete-user
///

serve(async (req: Request) => {
  // const reqJson = await req.json();
  try {
    // 環境変数からSupabaseクライアントを作成する
    const supabaseClient = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_ANON_KEY") ?? ""
    );

    // リクエストからJWTトークンを取得する
    const jwt = req.headers.get("Authorization")!.split(" ")[1];

    // サーバー側でJWTトークンを検証する
    const { data, error } = await supabaseClient.auth.getUser(jwt);
    if (error) {
      return new Response(JSON.stringify({ error: error.message }), {
        headers: { "Content-Type": "application/json" },
        status: 401, // 認証エラーの場合は401を返す
      });
    }

    // サービスロールキーを使ってユーザーを削除する
    const serviceClient = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
    );
    await serviceClient.auth.admin.deleteUser(data.user.id);

    return new Response(JSON.stringify({ success: true }), {
      headers: { "Content-Type": "application/json" },
      status: 200,
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { "Content-Type": "application/json" },
      status: 500, // 予期しないエラーの場合は500を返す
    });
  }
});
