import { create, createStore } from "zustand";
import {persist} from 'zustand/middleware';
interface AuthState {
  token: string | undefined;
  
}

interface AuthActions {
  setToken: (token: string | undefined) => void;
}

const defaultState : AuthState = {
  token: undefined
}

type AuthStore = AuthState & AuthActions;

export const createAuthStore = (initialState: AuthState = defaultState) => {
  return createStore<AuthStore>()((set) => ({
    ...initialState,
    setToken: (token) => set({ token })
  }))
}