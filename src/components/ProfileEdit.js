import React, { useState } from 'react';

const ProfileEdit = ({ profile, onSave }) => {
  const [name, setName] = useState(profile.name);
  const [bio, setBio] = useState(profile.bio);

  const handleSave = (e) => {
    e.preventDefault();
    onSave({ name, bio });
  }

  return (
    <div>
      <form onSubmit={handleSave}>
        <label>
          Name:
          <input type="text" value={name} onChange={(e) => setName(e.target.value)} />
        </label>
        <br />
        <label>
          Bio:
          <textarea value={bio} onChange={(e) => setBio(e.target.value)}></textarea>
        </label>
        <br />
        <button type="submit">Save</button>
      </form>
    </div>
  );
};

export default ProfileEdit;
