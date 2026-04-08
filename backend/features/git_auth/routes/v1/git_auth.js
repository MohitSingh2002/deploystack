const express = require('express');
const User = require('../../../../common/models/user');

const gitAuthRouter = express.Router();

gitAuthRouter.get('/v1/git-auth', async (req, res) => {
    let user = await User.findOne().populate('git');

    if (user.git && user.git.installationId === '') {
        return res.redirect(`https://github.com/apps/${user.git.slug}/installations/new`);
    }

    // TODO : Un-comment the below line
    const BASE_URL = `${req.protocol}://${req.get('host')}`;
    // const BASE_URL = 'https://8ffa-2409-4090-a011-380e-14c4-66f1-5251-b587.ngrok-free.app';

    const manifest = {
    name: "DeployStack" + Math.floor(1000000000 + Math.random() * 9000000000),
    url: BASE_URL,
    setup_url: `${BASE_URL}/setup`,
    hook_attributes: {
      url: `${BASE_URL}/webhook`
    },
    redirect_url: `${BASE_URL}/github/callback`,
    public: false,
    default_permissions: {
      issues: "write",
      contents: "read",
      metadata: "read"
    },
    default_events: ["issues", "issue_comment", "push"]
  };

  res.send(`
    <html>
      <body>
        <form id="f" action="https://github.com/settings/apps/new" method="post">
          <input type="hidden" name="manifest" value='${JSON.stringify(manifest)}' />
        </form>
        <script>
          document.getElementById('f').submit();
        </script>
      </body>
    </html>
  `);
});

module.exports = gitAuthRouter;
